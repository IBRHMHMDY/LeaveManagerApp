import 'package:flutter/material.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/custom_leave_card.dart';

class BuildCurrentMonthLeaves extends StatelessWidget {
  final List<LeaveRecord> leaves;

  const BuildCurrentMonthLeaves({super.key, required this.leaves});

  @override
  Widget build(BuildContext context) {
    if (leaves.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إجازات الشهر الحالي',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...leaves.map((leave) {
          return CustomLeaveCard(
            key: ValueKey(leave.id),
            leave: leave,
          );
        }),
      ],
    );
  }
}