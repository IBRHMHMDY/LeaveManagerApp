// lib/features/layout/presentation/screens/main_layout.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/layout_constants.dart';
import 'package:leave_manager/core/utils/notification_service.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/holiday_action_bottomsheet.dart';
import 'package:leave_manager/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:leave_manager/features/layout/presentation/cubit/layout_state.dart';
import 'package:leave_manager/features/layout/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

class MainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  StreamSubscription<String?>? _notificationSubscription;
  
  // 1. إضافة متغير لحفظ الـ ID المعلق في حالة الـ Cold Start
  int? _pendingHolidayActionId;

  @override
  void initState() {
    super.initState();
    _configureNotificationListener();
  }

  void _configureNotificationListener() {
    final notificationService = sl<NotificationService>();
    final initialPayload = notificationService.initialPayload;
    if (initialPayload != null) {
      _processPayload(initialPayload);
      notificationService.initialPayload = null; 
    }

    _notificationSubscription = selectNotificationStream.stream.listen((String? payload) {
      if (payload != null) {
        _processPayload(payload);
      }
    });
  }

  void _processPayload(String payload) {
    if (payload.startsWith('holiday_')) {
      final String holidayIdStr = payload.split('_').last;
      final int? holidayId = int.tryParse(holidayIdStr);
      
      if (holidayId != null && mounted) {
         _handleHolidayAction(holidayId);
      }
    }
  }

  void _handleHolidayAction(int holidayId) {
    final holidayState = context.read<HolidaysCubit>().state;
    
    // 2. التحقق مما إذا كانت العطلات قد تم تحميلها بالفعل أم لا
    if (holidayState is HolidaysLoaded) {
      _showBottomSheetForHoliday(holidayState, holidayId);
    } else {
      // 3. إذا لم يتم التحميل بعد (التطبيق في بداية التشغيل)، نحفظ الـ ID ليتم معالجته لاحقاً
      setState(() {
        _pendingHolidayActionId = holidayId;
      });
    }
  }

  // دالة مساعدة لفتح الـ BottomSheet لتجنب تكرار الكود
  void _showBottomSheetForHoliday(HolidaysLoaded state, int holidayId) {
    final holiday = state.financialYearHolidays.where((h) => h.id == holidayId).firstOrNull;
    
    if (holiday != null && mounted) {
      if (widget.navigationShell.currentIndex != 0) {
         widget.navigationShell.goBranch(0);
      }
      
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
           showHolidayActionBottomSheet(context, holiday);
        }
      });
    }
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel(); 
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
          
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: iconBrightness,
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
              systemNavigationBarColor: context.colorScheme.surface,
              systemNavigationBarIconBrightness: iconBrightness,
            ),
            // 4. استخدام MultiBlocListener للاستماع لعدة مهام
            child: MultiBlocListener(
              listeners: [
                BlocListener<LayoutCubit, LayoutState>(
                  listener: (context, state) {
                    if (state is LayoutExitWarning) {
                      AppToast.showWarning(context, state.message);
                    } else if (state is LayoutExitApproved) {
                      SystemNavigator.pop();
                    }
                  },
                ),
                // 5. إضافة مستمع لـ HolidaysCubit لمعالجة الـ Payload المعلق بمجرد اكتمال تحميل البيانات
                BlocListener<HolidaysCubit, HolidaysState>(
                  listener: (context, state) {
                    if (state is HolidaysLoaded && _pendingHolidayActionId != null) {
                      _showBottomSheetForHoliday(state, _pendingHolidayActionId!);
                      setState(() {
                        _pendingHolidayActionId = null; // تفريغ الحدث المعلق
                      });
                    }
                  },
                ),
              ],
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  context.read<LayoutCubit>().handlePopRequest();
                },
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