import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/features/app/presentation/bloc/navigation_cubit.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/rest_allowance/presentation/screens/views/extra_work_view.dart';
import 'package:leave_manager/features/rest_allowance/presentation/screens/views/holidays_view.dart';
// استيراد الشاشة الجديدة
import 'package:leave_manager/features/rest_allowance/presentation/screens/views/consumed_rest_allowance_view.dart';
import 'package:leave_manager/features/rest_allowance/presentation/widgets/add_extra_work_bottom_sheet.dart';
import 'package:leave_manager/features/rest_allowance/presentation/widgets/add_holiday_bottom_sheet.dart';
import 'package:leave_manager/features/rest_allowance/presentation/widgets/add_rest_allowance_bottom_sheet.dart.dart';

class RestAllowanceScreen extends StatefulWidget {
  const RestAllowanceScreen({super.key});

  @override
  State<RestAllowanceScreen> createState() => _RestAllowanceScreenState();
}

class _RestAllowanceScreenState extends State<RestAllowanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialTab = context.read<NavigationCubit>().state.restAllowanceTab;
    _tabController = TabController(
      length: 3, // تم التغيير إلى 3 تبويبات
      vsync: this,
      initialIndex: initialTab,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<NavigationCubit, NavigationState>(
      listener: (context, state) {
        if (state.selectedIndex == 2) {
          _tabController.animateTo(state.restAllowanceTab);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'بدلات الراحة',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          bottom: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurface.withAlpha(150),
            indicatorColor: colorScheme.primary,
            tabs: const [
              Tab(icon: Icon(Icons.history_rounded), text: 'بدلات الراحه'),
              Tab(icon: Icon(Icons.more_time_rounded), text: 'العمل الإضافي'),
              Tab(
                icon: Icon(Icons.event_available_rounded),
                text: 'العطلات الرسميه',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            ConsumedRestAllowanceView(), // إضافة الواجهة الجديدة
            ExtraWorkView(),
            HolidaysView(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(colorScheme),
      ),
    );
  }

  Widget? _buildFloatingActionButton(ColorScheme colorScheme) {
    final isRestAllowancesTab = _tabController.index == 0;
    final isExtraWorkTab = _tabController.index == 1;
    final isHolidaysTab = _tabController.index == 2;

    return FloatingActionButton.extended(
      onPressed: () {
        if (isExtraWorkTab) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const AddExtraWorkBottomSheet(),
          );
        } else if (isHolidaysTab) {
          final holidaysBloc = context.read<HolidaysBloc>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            builder: (_) => AddHolidayBottomSheet(bloc: holidaysBloc),
          );
        } else {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            builder: (_) => const AddRestAllowanceBottomSheet(),
          );
        }
      },
      backgroundColor: isExtraWorkTab
          ? AppColors.restAllowanceColor
          : colorScheme.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: Text(
        isRestAllowancesTab
            ? 'بدل راحه'
            : isExtraWorkTab
            ? 'عمل إضافي'
            : 'عطلة رسمية',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
