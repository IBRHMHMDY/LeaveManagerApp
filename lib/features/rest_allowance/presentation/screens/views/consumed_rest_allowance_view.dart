import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/history/widgets/custom_empty_state.dart';
import 'package:leave_manager/features/leaves/presentation/shared_widgets/custom_leave_card.dart';

class ConsumedRestAllowanceView extends StatelessWidget {
  const ConsumedRestAllowanceView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeavesBloc, LeavesState>(
      builder: (context, state) {
        if (state is LeavesLoaded) {
          // جلب الإجازات التي نوعها "بدل راحة" فقط
          final restAllowances = state.currentYearLeaves
              .where((leave) => leave.leaveType == LeaveType.restAllowance)
              .toList();

          if (restAllowances.isEmpty) {
            return const CustomEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0,
              bottom: 80.0,
            ),
            itemCount: restAllowances.length,
            itemBuilder: (context, index) {
              return CustomLeaveCard(leave: restAllowances[index]);
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}