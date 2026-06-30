import 'package:go_router/go_router.dart';
import '../../features/app/presentation/screens/splash_screen.dart';
import '../../features/app/presentation/screens/main_navigation_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
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
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) {
          // استقبال المتغير isFirstTime بأمان
          final isFirstTime = state.extra as bool? ?? false;
          return SettingsScreen(isFirstTime: isFirstTime);
        },
      ),
    ],
  );
}