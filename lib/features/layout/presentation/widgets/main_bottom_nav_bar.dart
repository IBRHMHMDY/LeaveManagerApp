// lib/features/layout/presentation/widgets/main_bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/features/layout/domain/entities/navigation_tab_entity.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;
  final List<NavigationTabEntity> tabs;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTabChanged,
      // توليد الوجهات ديناميكياً من القائمة
      destinations: tabs.map((tab) {
        return NavigationDestination(
          icon: Icon(tab.icon),
          selectedIcon: Icon(tab.selectedIcon),
          label: tab.label,
        );
      }).toList(),
    );
  }
}