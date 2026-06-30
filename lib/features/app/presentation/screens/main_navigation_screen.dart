import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vacation_tracker/core/constants/app_colors.dart';
import 'package:vacation_tracker/features/leaves/presentation/shared_widgets/show_add_leave_bottomsheet.dart';
import 'package:vacation_tracker/shared/widgets/theme_toggle_button.dart';
import 'package:vacation_tracker/features/leaves/presentation/history/screens/history_screen.dart';
import 'package:vacation_tracker/features/leaves/presentation/home/screens/home_screen.dart';
import 'package:vacation_tracker/features/settings/presentation/screens/settings_screen.dart';
import '../../../leaves/presentation/blocs/leaves_bloc.dart';
import '../../../settings/presentation/bloc/settings_bloc.dart';

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
      appBar: AppBar(
          title: Text('app_title'.tr()),
          centerTitle: false,
          actions: const [
          // LanguageToggleButton(),
          // SizedBox(width: 1),
          ThemeToggleButton(),
          SizedBox(width: 15),
        ],
        ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButton: _currentIndex != 2
          ? FloatingActionButton.extended(
              onPressed: () => showAddLeaveBottomSheet(context),
              icon: const Icon(Icons.add),
              label: const Text('إجازة جديدة'),
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'دفتر إجازاتي',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'الإعدادات'),
        ],
      ),
    );
  }
}
