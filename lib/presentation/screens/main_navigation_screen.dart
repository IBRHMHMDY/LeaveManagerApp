import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/constants/app_colors.dart';
import 'package:vacation_tracker/core/utils/helpers/show_add_leave_bottomsheet.dart';
import 'package:vacation_tracker/presentation/screens/history_screen.dart';
import 'package:vacation_tracker/presentation/screens/home_screen.dart';
import 'package:vacation_tracker/presentation/screens/settings_screen.dart';
import '../blocs/leaves/leaves_bloc.dart';
import '../blocs/settings/settings_bloc.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const SettingsScreen(isFirstTime: false),
  ];

  @override
  void initState() {
    super.initState();
    // تحميل البيانات الأساسية للتطبيق فور الدخول للشاشة الرئيسية
    context.read<SettingsBloc>().add(LoadSettingsEvent());
    context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => showAddLeaveBottomSheet(context),
          icon: const Icon(Icons.add),
          label: const Text('إجازة جديدة'),
          backgroundColor: AppColors.accentCoral,
          foregroundColor: Colors.white,
        ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.history), label: 'دفتر إجازاتي'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}