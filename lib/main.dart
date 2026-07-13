import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:leave_manager/core/di/injection_container.dart' as di;
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/features/app/presentation/bloc/navigation_cubit.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_bloc.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_events.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_event.dart';
import 'package:leave_manager/shared/themes/app_theme.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  runApp(const LeaveManagerAPP());
}

class LeaveManagerAPP extends StatelessWidget {
  const LeaveManagerAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<NavigationCubit>()),
        BlocProvider(create: (_) => di.sl<SettingsBloc>()),
        BlocProvider(create: (_) => di.sl<LeavesBloc>()),
        BlocProvider(
          create: (_) => di.sl<ExtraWorkBloc>()..add(GetExtraWorkDaysEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<HolidaysBloc>()..add(LoadHolidaysEvent()),
        ),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Leave Manager',
            
            // الاعتماد المباشر على تهيئة اللغات الأصلية لفلتر (RTL Support)
            supportedLocales: const [
              Locale('ar', 'EG'), // العربية - مصر
              Locale('en', 'US'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: const Locale('ar', 'EG'), // فرض اللغة العربية كافتراضية
            
            // -------------------------------------------------------//
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
