import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/presentation/screens/main_navigation_screen.dart';
import 'package:vacation_tracker/presentation/screens/settings_screen.dart';
import 'injection_container.dart' as di;
import 'presentation/blocs/settings/settings_bloc.dart';
import 'presentation/blocs/leaves/leaves_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // تهيئة الاعتماديات وقاعدة البيانات
  runApp(const VacationsTrackerApp());
}

class VacationsTrackerApp extends StatelessWidget {
  const VacationsTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          // بدء التحقق من وجود الإعدادات بمجرد فتح التطبيق
          create: (_) => di.sl<SettingsBloc>()..add(CheckSettingsEvent()),
        ),
        BlocProvider(create: (_) => di.sl<LeavesBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'تتبع الإجازات',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF008080)),
          useMaterial3: true,
          fontFamily: 'Cairo', // تأكد من إضافة الخط في pubspec.yaml
          
        ),
        home: const InitialRoutingScreen(),
      ),
    );
  }
}

class InitialRoutingScreen extends StatelessWidget {
  const InitialRoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsInitial) {
          // الإعدادات موجودة مسبقاً -> توجيه للرئيسية
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        } else if (state is SettingsNotFound) {
          // أول مرة يفتح التطبيق -> توجيه لشاشة الإعدادات
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SettingsScreen(isFirstTime: true,)),
          );
        }
      },
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}