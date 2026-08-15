// lib/features/home/presentation/widgets/build_current_month_leaves.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/leave_card.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/rest_allowances_card.dart';
import 'package:leave_manager/shared/widgets/displays/app_empty_state.dart';

class CurrentMonthLeavesSection extends StatelessWidget {
  final List<LeaveRecord> leaves;
  final List<ExtraWorkRecord> restAllowances;

  const CurrentMonthLeavesSection({
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
            Text(
              'إجازات الشهر الحالى ',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.onSurface,
              ),
            ),
            Text(
              now.toFormatCurrentMonthYear,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (leaves.isEmpty && restAllowances.isEmpty)
          const AppEmptyState(
            title: "السجل فارغ",
            content: "قم بتسجيل اجازتك الاولى",
          ),
        ...leaves.map((leave) {
          return LeaveCard(
            key: ValueKey('leave_${leave.id}'),
            leave: leave,
          );
        }),
        ...restAllowances.map((rest) {
          return RestAllowancesCard(
            key: ValueKey('extra_${rest.id}'),
            extrawork: rest,
          );
        }),
      ],
    );
  }
}
