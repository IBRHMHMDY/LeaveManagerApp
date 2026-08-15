import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/shared/widgets/displays/app_badge.dart';

class RestHeader extends StatelessWidget {
  const RestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'بدلات الراحه',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        AppBadge(
          title: FinancialYearCalculator.financialYearString,
          textColor: context.colorScheme.onSurface,
        ),
      ],
    );
  }
}