// lib/features/layout/presentation/screens/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/layout_constants.dart';
import 'package:leave_manager/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:leave_manager/features/layout/presentation/cubit/layout_state.dart';
import 'package:leave_manager/features/layout/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LayoutCubit>(),
      child: Builder(
        builder: (context) {
          // جلب حالة الثيم الحالي لتحديد لون الأيقونات (عكس لون الخلفية)
          final isDark = context.isDarkMode;
          final iconBrightness = isDark ? Brightness.light : Brightness.dark;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            // توحيد إعدادات شريط الحالة (العلوي) وشريط النظام (السفلي)
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // خلفية شفافة للعلوي
              statusBarIconBrightness: iconBrightness, // لون الأيقونات للعلوي
              statusBarBrightness: isDark ? Brightness.dark : Brightness.light, // مخصص لـ iOS
              systemNavigationBarColor: context.colorScheme.surface, // خلفية السفلي
              systemNavigationBarIconBrightness: iconBrightness, // لون الأيقونات للسفلي
            ),
            child: BlocListener<LayoutCubit, LayoutState>(
              listener: (context, state) {
                if (state is LayoutExitWarning) {
                  AppToast.showWarning(context, state.message);
                } else if (state is LayoutExitApproved) {
                  SystemNavigator.pop();
                }
              },
              child: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  context.read<LayoutCubit>().handlePopRequest();
                },
                child: Scaffold(
                  body: SafeArea(child: navigationShell),
                  bottomNavigationBar: MainBottomNavBar(
                    currentIndex: navigationShell.currentIndex,
                    tabs: LayoutConstants.appTabs,
                    onTabChanged: (index) {
                      navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
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