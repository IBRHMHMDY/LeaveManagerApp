import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/settings/settings_bloc.dart';
import 'main_navigation_screen.dart';
import 'settings_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // إرسال حدث التحقق من الإعدادات بمجرد فتح الشاشة
    context.read<SettingsBloc>().add(CheckSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        // بناءً على الكود المرفق، SettingsInitial تعني أن الإعدادات موجودة وجاهزة للتحميل
        if (state is SettingsInitial) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        } else if (state is SettingsNotFound) {
          // التطبيق يفتح لأول مرة
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SettingsScreen(isFirstTime: true)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_available, size: 80, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}