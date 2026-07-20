// lib/app/layout/widgets/main_bottom_nav_bar.dart
import 'package:flutter/material.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: colorScheme.shadow.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              );
            }
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: onTabChanged,
          backgroundColor: colorScheme.surface,
          elevation: 0,
          indicatorColor: colorScheme.primary.withAlpha(40),
          animationDuration: const Duration(milliseconds: 400),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home, color: colorScheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.home, color: colorScheme.primary),
              label: 'الرئيسية',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month, color: colorScheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.calendar_month, color: colorScheme.primary),
              label: 'الاجازات',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings, color: colorScheme.onSurfaceVariant),
              selectedIcon: Icon(Icons.settings, color: colorScheme.primary),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}