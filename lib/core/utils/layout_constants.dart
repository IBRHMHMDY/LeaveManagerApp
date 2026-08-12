// lib/features/layout/presentation/utils/layout_constants.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/features/layout/domain/entities/navigation_tab_entity.dart';

abstract class LayoutConstants {
  /// قائمة التبويبات الديناميكية للتطبيق
  static const List<NavigationTabEntity> appTabs = [
    NavigationTabEntity(
      label: 'الرئيسية',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      initialLocation: AppRouter.home,
    ),
    NavigationTabEntity(
      label: 'الإجازات',
      icon: Icons.calendar_month_outlined,
      selectedIcon: Icons.calendar_month_rounded,
      initialLocation: AppRouter.leaves,
    ),
    NavigationTabEntity(
      label: 'بدلات الراحة',
      icon: Icons.workspace_premium_outlined,
      selectedIcon: Icons.workspace_premium_rounded,
      initialLocation: AppRouter.restAllowances,
    ),
    NavigationTabEntity(
      label: 'الإعدادات',
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings_rounded,
      initialLocation: AppRouter.settings,
    ),
  ];
}