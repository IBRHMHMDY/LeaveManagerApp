import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:leave_manager/app/layout/widgets/main_appbar.dart';
import 'package:leave_manager/app/layout/widgets/main_bottom_nav_bar.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_event.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';

/// الواجهة الهيكلية الرئيسية (Layout) باستخدام GoRouter
class MainLayout extends StatelessWidget {
  /// الكائن المسؤول عن إدارة التبويبات والمقدم من GoRouter
  final StatefulNavigationShell navigationShell;

  const MainLayout({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    // يفضل استدعاء الأحداث هنا أو في طبقة الـ Router بدلاً من initState
    context.read<SettingsBloc>().add(LoadSettingsEvent());
    context.read<LeavesBloc>().add(LoadBalancesAndLeavesEvent());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness: 
            Theme.of(context).colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: MainAppBar(),
        ),
        body: SafeArea(
          // GoRouter يقوم تلقائياً بإدارة IndexedStack داخلياً عبر navigationShell
          child: navigationShell, 
        ),
        bottomNavigationBar: SafeArea(
          bottom: true,
          child: MainBottomNavBar(
            currentIndex: navigationShell.currentIndex,
            onTabChanged: (index) {
              // التنقل عبر الفروع (Branches) في GoRouter
              navigationShell.goBranch(
                index,
                // إعادة الفرع لحالته الأولى إذا تم الضغط عليه وهو مفعل بالفعل
                initialLocation: index == navigationShell.currentIndex,
              );
            },
          ),
        ),
      ),
    );
  }
}