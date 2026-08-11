// lib/features/home/presentation/widgets/build_balances_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'balance_circular_indicator.dart';

class BuildBalancesSection extends StatelessWidget {
  final LeaveBalance balance;
  final Settings settings;

  const BuildBalancesSection({
    super.key,
    required this.balance,
    required this.settings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: BalanceCircularIndicator(
            title: 'اعتيادي',
            remaining: balance.remainingRegular,
            total: settings.totalRegularLeaves,
            color: context.leaveColors.regular,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: BalanceCircularIndicator(
            title: 'عارضة',
            remaining: balance.remainingCasual,
            total: settings.totalCasualLeaves,
            color: context.leaveColors.casual,
          ),
        ),
      ],
    );
  }
}