// lib/app/layout/main_layout.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/app/layout/widgets/main_appbar.dart';
import 'package:leave_manager/app/layout/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class MainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // متغير لحفظ وقت آخر ضغطة على زر الرجوع
  DateTime? _currentBackPressTime;

  /// دالة معالجة حدث الرجوع
  void _onPopInvoked(bool didPop, dynamic result) {
    if (didPop) return;

    final now = DateTime.now();
    // إذا لم يضغط من قبل، أو مر أكثر من ثانيتين على آخر ضغطة
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      AppToast.showWarning(context, 'اضغط مرة أخرى للخروج من التطبيق');
    } else {
      // إغلاق التطبيق في حال الضغط مرتين متتاليتين خلال ثانيتين
      SystemNavigator.pop();
    }
  }

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
      // استخدام PopScope لاعتراض زر الرجوع في النظام
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
