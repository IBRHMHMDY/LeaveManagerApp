// lib/features/holidays/presentation/screens/holidays_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_event.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_state.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/add_holiday_bottom_sheet.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/custom_holiday_card.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/features/leaves/presentation/history/widgets/custom_empty_state.dart';


class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => sl<HolidaysBloc>()..add(LoadHolidaysEvent()),
      child:  const _HolidaysView(),
    );
  }
}

class _HolidaysView extends StatefulWidget {


  const _HolidaysView();

  @override
  State<_HolidaysView> createState() => _HolidaysViewState();
}

// 1. إضافة with WidgetsBindingObserver
class _HolidaysViewState extends State<_HolidaysView> with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    // 2. تسجيل المراقب (Observer) عند بدء الشاشة
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // 3. إزالة المراقب عند إغلاق الشاشة لتجنب الـ Memory Leaks
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 4. الاستماع لتغيرات حالة التطبيق (App Lifecycle)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // إذا عاد التطبيق إلى الواجهة (العمل من الخلفية)
    if (state == AppLifecycleState.resumed) {
      // قم بإعادة جلب البيانات لتحديث تواريخ الإجازات وحالة "الإجازة القادمة"
      context.read<HolidaysBloc>().add(LoadHolidaysEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإجازات الرسمية'),
      ),
      body: BlocConsumer<HolidaysBloc, HolidaysState>(
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

            return Column(
              children: [
                // قائمة الإجازات
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: state.holidays.length,
                    itemBuilder: (context, index) {
                      final holiday = state.holidays[index];
                      return CustomHolidayCard(holiday: holiday);
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHolidayDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('إضافة إجازة'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  void _showAddHolidayDialog(BuildContext context) {
    final bloc = context.read<HolidaysBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AddHolidayBottomSheet(bloc: bloc),
    );
  }
}