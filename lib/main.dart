import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/di/injection_container.dart' as di;
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/shared/themes/app_theme.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('en', 'US'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', 'EG'),
      startLocale: const Locale('ar', 'EG'),
      child: const LeaveManagerAPP(),
    ),
  );
}

class LeaveManagerAPP extends StatelessWidget {
  const LeaveManagerAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<SettingsBloc>()),
        BlocProvider(create: (_) => di.sl<LeavesBloc>()),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'مدير أجازاتى',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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