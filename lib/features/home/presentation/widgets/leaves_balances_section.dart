// lib/features/home/presentation/widgets/leaves_balances_section.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/shared/widgets/widgets.dart'; // يجلب كل الويدجتس العامة

class LeavesBalancesSection extends StatelessWidget {
  final LeaveBalance balance;
  final Settings settings;

  const LeavesBalancesSection({
    super.key,
    required this.balance,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الصف الأول: الأرصدة الدائرية (الاعتيادي والعارضة)
        Row(
          children: [
            Expanded(
              child: AppCircularProgressCard(
                title: 'الاعتيادي',
                currentValue: balance.remainingRegular,
                maxValue: settings.totalRegularLeaves,
                progressColor: context.leaveColors.regular,
                onTap: () => context.go(AppRouter.leaves),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AppCircularProgressCard(
                title: 'العارضة',
                currentValue: balance.remainingCasual,
                maxValue: settings.totalCasualLeaves,
                progressColor: context.leaveColors.casual,
                onTap: () => context.go(AppRouter.leaves),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        // الصف الثاني: الإجازة المرضية (شريط تقدم خطي)
        AppProgressCard(
          title: 'المرضي',
          currentValue: balance.remainingSick,
          maxValue: settings.totalSickLeaves,
          progressColor: context.leaveColors.sick,
          onTap: () => context.go(AppRouter.leaves),
        ),
      ],
    );
  }
}