import 'package:go_router/go_router.dart';
import 'package:leave_manager/features/app/presentation/screens/splash_screen.dart';
import 'package:leave_manager/features/app/presentation/screens/main_navigation_bottom.dart';
import 'package:leave_manager/features/settings/presentation/screens/settings_screen.dart';
// استيراد الشاشة المجمعة الجديدة بدلاً من الشاشات القديمة المنفصلة
import 'package:leave_manager/features/rest_allowance/presentation/screens/rest_allowance_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String settings = '/settings';
  // إضافة اسم مسار ثابت للشاشة الجديدة
  static const String restAllowance = '/rest-allowance';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash, 
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const MainNavigationBottom(),
      ),
      GoRoute(
        path: settings,
        builder: (context, state) {
          final isFirstTime = state.extra as bool? ?? false;
          return SettingsScreen(isFirstTime: isFirstTime);
        },
      ),
      // المسار الجديد الموحد لإدارة بدل الراحة
      GoRoute(
        path: restAllowance,
        name: 'restAllowance',
        builder: (context, state) => const RestAllowanceScreen(),
      ),
    ],
  );
}