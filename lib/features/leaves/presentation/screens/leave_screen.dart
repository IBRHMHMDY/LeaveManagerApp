import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/core/utils/extenstions/leave_filter_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/build_filter_chips.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/show_add_leave_bottomsheet.dart';
import 'package:leave_manager/shared/themes/app_colors.dart';
import 'package:leave_manager/shared/widgets/add_leave_button.dart';
import 'package:leave_manager/shared/widgets/custom_empty_state.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/custom_leave_card.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/leave_list_shimmer.dart';

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
      appBar: AppBar(
        title: const Text('الاجازات'),
      ),
      body: BlocListener<LeavesBloc, LeavesState>(
        listener: (context, state) {
          if (state is LeaveDeletedSuccess) {
            AppToast.showSuccess(
              context,
              'تم حذف الإجازة بنجاح',
            );
          } else if (state is LeavesError) {
            AppToast.showError(context, state.message);
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
                    final filteredLeaves = state.currentYearLeaves.where((leave) {
                      if (_selectedFilter == LeaveFilter.all) {
                        return true;
                      }
                      if (_selectedFilter == LeaveFilter.regular) {
                        return leave.leaveType == LeaveType.regular;
                      }
                      return leave.leaveType == LeaveType.casual;
                    }).toList();
                    if (filteredLeaves.isEmpty) {
                      return const CustomEmptyState();
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w,
                        vertical: 8.0.h,
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
                  
                  return  const LeaveListShimmer();
                },
              ),
            ),
          ],
        ),
      ),
        floatingActionButton: AddLeaveButton(
        onTap: () => showAddLeaveBottomSheet(context),
        label: const Text('إضافة إجازة'),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.accentCoral,
        foregroundColor: Colors.white,
      ),
      
    );
  }
}