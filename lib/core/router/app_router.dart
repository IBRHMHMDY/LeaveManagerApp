import 'package:go_router/go_router.dart';
import 'package:leave_manager/app/layout/main_layout.dart';
import 'package:leave_manager/features/leaves/presentation/screens/leave_screen.dart';
import '../../app/splash/splash_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String leave = '/leave';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: leave,
        builder: (context, state) => const LeaveScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) {
          final isFirstTime = state.extra as bool? ?? false;
          return SettingsScreen(isFirstTime: isFirstTime);
        },
      ),
    ],
  );
}