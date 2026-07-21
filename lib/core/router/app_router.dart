import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/app/splash/splash_screen.dart';
import 'package:leave_manager/app/layout/main_layout.dart';
import 'package:leave_manager/features/holidays/presentation/screens/holidays_screen.dart';
import 'package:leave_manager/features/home/presentation/screens/home_screen.dart';
import 'package:leave_manager/features/leaves/presentation/screens/leave_screen.dart';
import 'package:leave_manager/features/settings/presentation/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String leaves = '/leaves';
  static const String holidays = '/holidays';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // استخدام StatefulShellRoute.indexedStack لإدارة التبويبات
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // حقن الـ navigationShell داخل الـ Layout الرئيسي
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // الفرع الأول: الرئيسية
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: holidays,
                builder: (context, state) => const HolidaysScreen(),
              ),

            ],
          ),
          // الفرع الثاني: الإجازات
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: leaves,
                builder: (context, state) => const LeaveScreen(),
              ),
            ],
          ),
          // الفرع الثالث: الإعدادات
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: settings,
                builder: (context, state) => const SettingsScreen(isFirstTime: false),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}