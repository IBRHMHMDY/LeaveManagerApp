import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/core/utils/extenstions/leave_filter_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/build_filter_chips.dart';
import 'package:leave_manager/shared/widgets/custom_empty_state.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/custom_leave_card.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

// استيراد الشيمر الجديد
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
      body: SafeArea(
        child: BlocListener<LeavesBloc, LeavesState>(
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
              // شريط التصفية بالتصميم العصري الجديد
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
        
                      // حالة عدم وجود بيانات باستخدام Lottie
                      if (filteredLeaves.isEmpty) {
                        return const CustomEmptyState();
                      }
        
                      // استخدام ListView.builder للقوائم الطويلة حسب معايير 2026
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
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
      ),
    );
  }
}