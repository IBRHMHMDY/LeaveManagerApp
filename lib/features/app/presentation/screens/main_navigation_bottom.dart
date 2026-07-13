import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/app/presentation/bloc/navigation_cubit.dart';
import 'package:leave_manager/features/app/presentation/widgets/main_appbar.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/rest_allowance/presentation/screens/rest_allowance_screen.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/history/screens/history_screen.dart';
import 'package:leave_manager/features/leaves/presentation/home/screens/home_screen.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_events.dart';
import 'package:leave_manager/features/settings/presentation/screens/settings_screen.dart';


class MainNavigationBottom extends StatefulWidget {
  const MainNavigationBottom({super.key});

  @override
  State<MainNavigationBottom> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationBottom> {

  final List<Widget> _screens = [
    const HomeScreen(),
    const HistoryScreen(),
    const RestAllowanceScreen(),
    const SettingsScreen(isFirstTime: false),
  ];

  @override
  void initState() {
    super.initState();
    context.read<NavigationCubit>();
    context.read<SettingsBloc>().add(LoadSettingsEvent());
    context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());
  }

 @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const MainAppbar(),
          body: IndexedStack(
            index: state.selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: state.selectedIndex,
            onDestinationSelected: (index) {
              // عند الضغط السفلي، ننتقل للتبويب ونصفّر التبويب الداخلي افتراضياً
              context.read<NavigationCubit>().changeTab(selectedIndex: index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_rounded),
                label: 'الرئيسية',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month_rounded),
                label: 'الإجازات',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_time_rounded),
                label: 'بدل الراحة',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_rounded),
                label: 'الإعدادات',
              ),
            ],
          ),
        );
      },
    );
  }
}