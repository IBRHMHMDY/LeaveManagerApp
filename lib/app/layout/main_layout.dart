import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/app/layout/widgets/main_appbar.dart';
import 'package:leave_manager/app/layout/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_event.dart';
import 'package:leave_manager/shared/themes/app_colors.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/show_add_leave_bottomsheet.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/screens/leave_screen.dart';
import 'package:leave_manager/features/home/presentation/screens/home_screen.dart';
import 'package:leave_manager/features/settings/presentation/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LeaveScreen(),
    const SettingsScreen(isFirstTime: false),
  ];

  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettingsEvent());
    context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
  }

  void _onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MainAppbar(),
      ),
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: MainBottomNavBar(currentIndex: currentIndex, onTabChanged: _onTabChanged),
      floatingActionButton: currentIndex != 2
          ? FloatingActionButton.extended(
              onPressed: () => showAddLeaveBottomSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('اجازه جديده'),
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}
