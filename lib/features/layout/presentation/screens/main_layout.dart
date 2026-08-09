// lib/app/layout/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/features/layout/presentation/widgets/main_appbar.dart';
import 'package:leave_manager/features/layout/presentation/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class MainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  DateTime? _currentBackPressTime;

  void _onPopInvoked(bool didPop, dynamic result) {
    if (didPop) return;

    final now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      AppToast.showWarning(context, 'اضغط مرة أخرى للخروج من التطبيق');
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: context.colorScheme.surface,
        systemNavigationBarIconBrightness: context.isDarkMode 
            ? Brightness.light 
            : Brightness.dark,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvoked,
        child: Scaffold(
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: MainAppBar(),
          ),
          body: widget.navigationShell,
          bottomNavigationBar: MainBottomNavBar(
            currentIndex: widget.navigationShell.currentIndex,
            onTabChanged: (index) {
              widget.navigationShell.goBranch(
                index,
                initialLocation: index == widget.navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}