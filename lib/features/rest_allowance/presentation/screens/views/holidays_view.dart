import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_event.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_state.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/widgets/custom_holiday_card.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/features/leaves/presentation/history/widgets/custom_empty_state.dart';

class HolidaysView extends StatefulWidget {
  const HolidaysView({super.key});

  @override
  State<HolidaysView> createState() => _HolidaysViewState();
}

class _HolidaysViewState extends State<HolidaysView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // التخلص من المراقب لمنع تسريب الذاكرة (Memory Leak)
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      context.read<HolidaysBloc>().add(LoadHolidaysEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HolidaysBloc, HolidaysState>(
      listener: (context, state) {
        if (state is HolidayOperationSuccess) {
          AppNotifications.showSuccess(context, state.message);
        } else if (state is HolidaysError) {
          AppNotifications.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is HolidaysLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HolidaysLoaded) {
          if (state.holidays.isEmpty) {
            return const CustomEmptyState();
          }
          return ListView.builder(
            // تم إضافة مسافة سفلية (bottom: 80) لتجنب تقاطع القائمة مع الـ FAB
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
            itemCount: state.holidays.length,
            itemBuilder: (context, index) {
              final holiday = state.holidays[index];
              return CustomHolidayCard(holiday: holiday);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}