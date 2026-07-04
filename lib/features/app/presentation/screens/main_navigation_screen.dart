import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/shared_widgets/show_add_leave_bottomsheet.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/history/screens/history_screen.dart';
import 'package:leave_manager/features/leaves/presentation/home/screens/home_screen.dart';
import 'package:leave_manager/features/settings/presentation/screens/settings_screen.dart';


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
    context.read<SettingsBloc>().add(LoadSettingsEvent());
    context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('دفتر أجازاتى'),
          centerTitle: false,

        ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton.extended(
              onPressed: () => showAddLeaveBottomSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('اجازه جديده'),
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
          NavigationDestination(
            icon:  Icon(Icons.checklist),
            label: 'الأجازات',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}
