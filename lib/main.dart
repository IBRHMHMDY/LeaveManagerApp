// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/home/presentation/cubit/home_cubit.dart';
import 'package:leave_manager/shared/themes/app_theme.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const LeaveManagerApp());
}

class LeaveManagerApp extends StatelessWidget {
  const LeaveManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844), 
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<SettingsBloc>()),
            BlocProvider(create: (_) => sl<HomeCubit>()),
            BlocProvider(create: (_) => sl<LeavesBloc>()),
            BlocProvider(create: (_) => sl<ThemeCubit>()),
            BlocProvider(
              create: (_) => sl<HolidaysCubit>()..loadHolidays(),
            ),
          ],
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'مدير اجازاتى',
                supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                locale: const Locale('ar', 'EG'),
                themeMode: themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}