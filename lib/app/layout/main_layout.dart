import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/app/layout/widgets/main_appbar.dart';
import 'package:leave_manager/app/layout/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/show_add_leave_bottomsheet.dart';
import 'package:leave_manager/shared/themes/app_colors.dart';
import 'package:leave_manager/shared/widgets/add_leave_button.dart';

/// الواجهة الهيكلية الرئيسية (Layout) باستخدام GoRouter
class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness:
            Theme.of(context).colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MainAppBar(),
        ),
        body: SafeArea(
          child: navigationShell,
        ),
        floatingActionButton: _buildFloatingActionButton(context),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: MainBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTabChanged: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;
    if (currentIndex > 1) {
      return null;
    }

    return AddLeaveButton(
      onTap: () => showAddLeaveBottomSheet(context),
      label: const Text('إضافة إجازة'),
      icon: const Icon(Icons.add),
      backgroundColor:  AppColors.primaryTeal,
      foregroundColor: Colors.white,
    );
  }
}
