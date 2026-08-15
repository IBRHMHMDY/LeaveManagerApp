// lib/features/rest_allowances/presentation/widgets/rest_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_extra_work_bottomsheet.dart';
import 'package:leave_manager/shared/widgets/buttons/app_primary_button.dart';

class AddBalanceButton extends StatelessWidget {
  const AddBalanceButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: AppPrimaryButton(
          backgroundColor: context.colorScheme.primary,
          onPressed: () => showAddExtraWorkBottomSheet(context),
          icon: Icons.add_circle_outline_rounded,
          label: 'إضافة رصيد',
        ),
      ),
    );
  }
}