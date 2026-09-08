import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:leave_manager/features/settings/presentation/bloc/settings_state.dart';
import 'package:leave_manager/shared/widgets/displays/app_badge.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'مدير اجازاتى',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: context.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoaded) {
              return AppBadge(
                title: "السنه الماليه ${FinancialYearCalculator.getYearString(
                  state.settings.financialYearType,
                )}",
                textColor: context.colorScheme.onSurface,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
