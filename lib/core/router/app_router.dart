import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/app/layout/widgets/main_appbar.dart';
import 'package:leave_manager/app/splash/splash_screen.dart';
import 'package:leave_manager/app/layout/main_layout.dart';
import 'package:leave_manager/features/holidays/presentation/screens/holidays_screen.dart';
import 'package:leave_manager/features/home/presentation/screens/home_screen.dart';
import 'package:leave_manager/features/leaves/presentation/screens/leave_screen.dart';
import 'package:leave_manager/features/rest_allowances/presentation/screens/rest_allowances_screen.dart';
import 'package:leave_manager/features/settings/presentation/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String leaves = '/leaves';
  static const String holidays = '/holidays';
  static const String restAllowances = '/rest_allowances';
  static const String settings = '/settings';
  static const String setup = '/setup';

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: setup,
        builder: (context, state) => const Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: MainAppBar(),
          ),
          body: SafeArea(child: SettingsScreen(isFirstTime: true)),
        ),
      ),
      // إدارة الـ Bottom Navigation باستخدام StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // الفرع الأول (0): الرئيسية 
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
          // الفرع الثاني (1): الإجازات
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: leaves,
                builder: (context, state) => const LeaveScreen(),
              ),
            ],
          ),
          // الفرع الثالث (2): بدلات الراحة
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: restAllowances,
                builder: (context, state) => const RestAllowancesScreen(),
              ),
            ],
          ),
          // الفرع الرابع (3): الإعدادات
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: settings,
                builder: (context, state) {
                  final isFirstTime = state.extra as bool? ?? false;
                  return SettingsScreen(isFirstTime: isFirstTime);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}