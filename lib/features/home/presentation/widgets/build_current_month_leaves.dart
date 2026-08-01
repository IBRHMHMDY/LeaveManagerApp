// lib/features/home/presentation/widgets/build_current_month_leaves.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/custom_leave_card.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowances_card.dart';
import 'package:leave_manager/shared/widgets/custom_empty_state.dart';

class BuildCurrentMonthLeaves extends StatelessWidget {
  final List<LeaveRecord> leaves;
  final List<ExtraWorkRecord> restAllowances;

  const BuildCurrentMonthLeaves({
    super.key,
    required this.leaves,
    required this.restAllowances,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'إجازات الشهر الحالى ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              now.toFormatCurrentMonthYear,
              style: const TextStyle(
                color: AppColors.primaryTeal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
    if(leaves.isEmpty && restAllowances.isEmpty)
      const CustomEmptyState(titleEmpty: "لا توجد بيانات", contentEmpty: "لا توجد اجازات لهذا الشهر"),
    
        
        ...leaves.map((leave) {
          return CustomLeaveCard(key: ValueKey('leave_${leave.id}'), leave: leave);
        }),
        
        // عرض بدلات الراحة المستهلكة أو العمل المكتسب في هذا الشهر
        ...restAllowances.map((allowance) {
          return RestAllowancesCard(
            key: ValueKey('extra_${allowance.id}'),
            extrawork: allowance,
          );
        }),
      ],
    );
  }
}