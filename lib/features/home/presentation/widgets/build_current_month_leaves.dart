import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/custom_leave_card.dart';
import 'package:leave_manager/shared/themes/app_colors.dart';

class BuildCurrentMonthLeaves extends StatelessWidget {
  final List<LeaveRecord> leaves;

  const BuildCurrentMonthLeaves({super.key, required this.leaves});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    if (leaves.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'إجازات الشهر الحالي',
             style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              )
            ),
            Text(
              now.currentMonthYear,
              style: const TextStyle(
                color: AppColors.primaryTeal,
                fontSize: 16,
                fontWeight: FontWeight.bold
              )
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...leaves.map((leave) {
          return CustomLeaveCard(key: ValueKey(leave.id), leave: leave);
        }),
      ],
    );
  }
}
