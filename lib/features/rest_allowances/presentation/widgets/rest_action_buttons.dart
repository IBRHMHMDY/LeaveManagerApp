// lib/features/rest_allowances/presentation/widgets/rest_action_buttons.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_extra_work_bottomsheet.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_rest_allowances_bottomsheet.dart';

class RestActionButtons extends StatelessWidget {
  const RestActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                ),
                onPressed: () => showAddExtraWorkBottomSheet(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('اضافه رصيد'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                ),
                onPressed: () => showRestAllowancesBottomSheet(context),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('استهلاك رصيد'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}