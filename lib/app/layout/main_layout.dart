import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/app/layout/widgets/main_appbar.dart';
import 'package:leave_manager/app/layout/widgets/main_bottom_nav_bar.dart';

/// الواجهة الهيكلية الرئيسية (Layout) باستخدام GoRouter
class MainLayout extends StatelessWidget {
  /// الكائن المسؤول عن إدارة التبويبات والمقدم من GoRouter
  final StatefulNavigationShell navigationShell;

  const MainLayout({
    super.key,
    required this.navigationShell,
  });

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
          // GoRouter يقوم تلقائياً بإدارة IndexedStack داخلياً عبر navigationShell
          child: navigationShell, 
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: MainBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTabChanged: (index) {
              // التنقل عبر الفروع (Branches) في GoRouter
              navigationShell.goBranch(
                index,
                // إعادة الفرع لحالته الأولى إذا تم الضغط عليه وهو مفعل بالفعل
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}