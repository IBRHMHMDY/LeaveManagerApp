// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/features/settings/presentation/widgets/settings_header.dart';
import 'package:leave_manager/features/splash/presentation/screens/splash_screen.dart';
import 'package:leave_manager/features/layout/presentation/screens/main_layout.dart';
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
          appBar: SettingsHeader(),
          body: SafeArea(child: SettingsScreen(isFirstTime: true)),
        ),
      ),
      GoRoute(
        path: holidays,
        builder: (context, state) => const HolidaysScreen(),
      ),
      // Bottom Navigation باستخدام StatefulShellRoute
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // Branch (0): Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch (1): Leaves
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: leaves,
                builder: (context, state) => const LeaveScreen(),
              ),
            ],
          ),

          // Branch (2): Rest Allowances
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: restAllowances,
                builder: (context, state) => const RestAllowancesScreen(),
              ),
            ],
          ),

          // Branch (3): Settings
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
