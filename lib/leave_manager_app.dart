// lib/leave_manager_app.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/home/presentation/cubit/home_cubit.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/shared/themes/app_theme.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';

class LeaveManagerApp extends StatefulWidget {
  const LeaveManagerApp({super.key});

  @override
  State<LeaveManagerApp> createState() => _LeaveManagerAppState();
}

class _LeaveManagerAppState extends State<LeaveManagerApp> {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SettingsBloc>()),
        BlocProvider(create: (_) => sl<HomeCubit>()),
        BlocProvider(create: (_) => sl<LeavesBloc>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<HolidaysCubit>()..loadHolidays()),
        BlocProvider(create: (_) => sl<RestAllowancesBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'مدير إجازاتي',
            supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('ar', 'EG'),
            themeMode: themeMode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
