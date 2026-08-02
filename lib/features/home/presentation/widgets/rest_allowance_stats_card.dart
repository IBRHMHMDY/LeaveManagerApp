// lib/features/home/presentation/widgets/rest_allowance_stats_card.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/home/presentation/widgets/rest_allowances_stats_button.dart';

class RestAllowanceStatsCard extends StatelessWidget {
  final int totalAvailableDays;
  final int totalConsumedDays;

  const RestAllowanceStatsCard({
    super.key,
    required this.totalAvailableDays,
    required this.totalConsumedDays,
  });

  @override
  Widget build(BuildContext context) {
    final restColor = context.leaveColors.restAllowance;
    final casualColor = context.leaveColors.casual; 

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadii.lg,
        border: Border.all(
          color: restColor.withOpacity(context.isDarkMode ? 0.2 : 0.6),
          width: 1.5,
        ),
        boxShadow: [
          if (!context.isDarkMode)
            BoxShadow(
              color: context.colorScheme.shadow.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'بدلات الراحة',
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                title: 'متاح',
                value: totalAvailableDays,
                color: restColor,
              ),
              _buildDivider(context),
              _StatItem(
                title: 'مستهلك',
                value: totalConsumedDays,
                color: casualColor,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm, left: AppSpacing.lg, right: AppSpacing.lg, bottom: 0),
            child: const RestAllowancesStatsButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 60,
      width: 1,
      color: context.colorScheme.outlineVariant.withOpacity(0.3),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final int value;
  final Color color;

  const _StatItem({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          '$value',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        Text(
          'أيام',
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}