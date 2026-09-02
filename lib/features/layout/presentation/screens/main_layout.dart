// lib/features/layout/presentation/screens/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/layout_constants.dart';
import 'package:leave_manager/core/utils/notifications/notification_flow_manager.dart';
import 'package:leave_manager/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:leave_manager/features/layout/presentation/cubit/layout_state.dart';
import 'package:leave_manager/features/layout/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

class MainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver{
  late final NotificationFlowManager _flowManager;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _flowManager = sl<NotificationFlowManager>();
    _flowManager.init();
    
    // استدعاء جلب الإشعارات (والذي سيفعل عملية التنظيف تلقائياً)
    context.read<NotificationsBloc>().add(LoadNotificationsEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // عند عودة التطبيق من الخلفية، قم بتحديث الإشعارات لضمان دقة العداد (Badge)
      context.read<NotificationsBloc>().add(LoadNotificationsEvent());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // تأمين إغلاق Streams لمنع Memory Leaks وفقاً لمعايير 2026
    _flowManager.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LayoutCubit>(),
      child: Builder(
        builder: (context) {
          final isDark = context.isDarkMode;
          final iconBrightness = isDark ? Brightness.light : Brightness.dark;

          return BlocListener<LayoutCubit, LayoutState>(
            listener: (context, state) {
              if (state is LayoutExitWarning) {
                AppToast.showWarning(context, state.message);
              } else if (state is LayoutExitApproved) {
                SystemNavigator.pop();
              }
            },
            child: PopScope(
              // 1. منع الخروج التلقائي نهائياً لإعطاء الأولوية للتحكم اليدوي
              canPop: false, 
              onPopInvokedWithResult: (bool didPop, Object? result) {
                if (didPop) return;
                
                // 2. التحقق من التبويب الحالي
                if (widget.navigationShell.currentIndex != 0) {
                  // 3. العودة للرئيسية إذا لم نكن فيها (Index 0)
                  widget.navigationShell.goBranch(
                    0,
                    initialLocation: true,
                  );
                } else {
                  // 4. طلب الخروج عبر Cubit إذا كنا في الرئيسية بالفعل
                  context.read<LayoutCubit>().handlePopRequest();
                }
              },
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: iconBrightness,
                  statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
                  systemNavigationBarColor: context.colorScheme.surface,
                  systemNavigationBarIconBrightness: iconBrightness,
                ),
                child: Scaffold(
                  body: SafeArea(child: widget.navigationShell),
                  bottomNavigationBar: MainBottomNavBar(
                    currentIndex: widget.navigationShell.currentIndex,
                    tabs: LayoutConstants.appTabs,
                    onTabChanged: (index) {
                      widget.navigationShell.goBranch(
                        index,
                        initialLocation: index == widget.navigationShell.currentIndex,
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}