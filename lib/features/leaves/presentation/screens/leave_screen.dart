// lib/features/leaves/presentation/screens/leave_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/core/utils/extenstions/leave_filter_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/show_add_leave_bottomsheet.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/custom_leave_card.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/leave_list_shimmer.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({super.key});

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  LeaveFilter _selectedFilter = LeaveFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(
        title: 'الاجازات',
      ),
      body: BlocListener<LeavesBloc, LeavesState>(
        listener: (context, state) {
          if (state is LeaveDeletedSuccess) {
            AppToast.showSuccess(context, 'تم حذف الإجازة بنجاح');
          } else if (state is LeavesError) {
            AppToast.showError(context, state.message);
          }
        },
        child: Column(
          children: [
            AppFilterChips<LeaveFilter>(
              selectedValue: _selectedFilter,
              onChanged: (newFilter) {
                setState(() {
                  _selectedFilter = newFilter;
                });
              },
              items: const [
                AppFilterChipItem(
                  value: LeaveFilter.all,
                  label: 'الكل',
                  icon: Icons.all_inclusive_rounded,
                ),
                AppFilterChipItem(
                  value: LeaveFilter.regular,
                  label: 'اعتيادي',
                  icon: Icons.event_available_rounded,
                ),
                AppFilterChipItem(
                  value: LeaveFilter.casual,
                  label: 'عارضة',
                  icon: Icons.event_busy_rounded,
                ),
              ],
            ),

            Expanded(
              child: BlocBuilder<LeavesBloc, LeavesState>(
                builder: (context, state) {
                  if (state is LeavesLoaded) {
                    final filteredLeaves = state.currentYearLeaves.where((
                      leave,
                    ) {
                      if (_selectedFilter == LeaveFilter.all) {
                        return true;
                      }
                      if (_selectedFilter == LeaveFilter.regular) {
                        return leave.leaveType == LeaveType.regular;
                      }
                      return leave.leaveType == LeaveType.casual;
                    }).toList();
                    if (filteredLeaves.isEmpty) {
                      return const AppEmptyState(
                        title: 'لا توجد اجازات مسجله حتى الآن',
                        content: 'قم بتسجيل اجازتك الاولى',
                        icon: Icons.import_contacts_outlined,
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: filteredLeaves.length,
                      itemBuilder: (context, index) {
                        final leave = filteredLeaves[index];
                        return CustomLeaveCard(
                          key: ValueKey(leave.id),
                          leave: leave,
                        );
                      },
                    );
                  }

                  return const LeaveListShimmer();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AppFloatingButton.extended(
        onPressed: () => showAddLeaveBottomSheet(context),
        backgroundColor: context.colorScheme.primary,
        label: 'إجازة جديدة',
        icon: Icons.add,
      ),
    );
  }
}
