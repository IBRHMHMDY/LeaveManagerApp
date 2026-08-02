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
      color: context.colorScheme.primaryContainer.withOpacity(0.12), // بديل withAlpha(30)
      shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
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
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'العام المالى الحالى',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.w900
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