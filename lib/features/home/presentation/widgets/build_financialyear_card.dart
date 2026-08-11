// lib/features/home/presentation/widgets/build_financialyear_card.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';

class BuildFinancialYearCard extends StatelessWidget {
  const BuildFinancialYearCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colorScheme.primaryContainer.withAlpha(30),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: context.colorScheme.primary,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'العام المالى الحالى',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                      
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    FinancialYearCalculator.financialYearString,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}