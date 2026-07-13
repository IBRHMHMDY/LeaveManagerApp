import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/core/utils/extenstions/leave_filter_extension.dart';
import 'package:leave_manager/features/leaves/presentation/history/widgets/custom_empty_state.dart';
import 'package:leave_manager/features/leaves/presentation/shared_widgets/custom_leave_card.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/history/widgets/build_filter_chips.dart';
import 'package:leave_manager/features/leaves/presentation/shared_widgets/show_add_leave_bottomsheet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  LeaveFilter _selectedFilter = LeaveFilter.all;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: BlocListener<LeavesBloc, LeavesState>(
        listener: (context, state) {
          if (state is LeaveDeletedSuccess) {
            AppNotifications.showSuccess(
              context,
              'تم حذف الإجازة واسترداد الرصيد بنجاح.',
            );
          } else if (state is LeavesError) {
            // عرض الخطأ إن وجد
            AppNotifications.showError(context, state.message);
          }
        },
        child: Column(
          children: [
            BuildFilterChips(
              selectedFilter: _selectedFilter,
              onFilterChanged: (newFilter) {
                setState(() {
                  _selectedFilter = newFilter;
                });
              },
            ),
            Expanded(
              child: BlocBuilder<LeavesBloc, LeavesState>(
                builder: (context, state) {
                  if (state is LeavesLoaded) {
                    final filteredLeaves = state.currentYearLeaves.where((
                      leave,
                    ) {
                      // 1. استبعاد بدلات الراحة بشكل كامل من هذه الشاشة
                      if (leave.leaveType == LeaveType.restAllowance){
                        return false;
                      }

                      // 2. تطبيق الفلتر على باقي الأنواع
                      if (_selectedFilter == LeaveFilter.all) return true;
                      if (_selectedFilter == LeaveFilter.regular) {
                        return leave.leaveType == LeaveType.regular;
                      }
                      if (_selectedFilter == LeaveFilter.casual) {
                        return leave.leaveType == LeaveType.casual;
                      } else {
                        return false;
                      }
                    }).toList();

                    if (filteredLeaves.isEmpty) {
                      return const CustomEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      itemCount: filteredLeaves.length,
                      itemBuilder: (context, index) {
                        final leave = filteredLeaves[index];
                        return CustomLeaveCard(leave: leave);
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddLeaveBottomSheet(context),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'تسجيل إجازة',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
