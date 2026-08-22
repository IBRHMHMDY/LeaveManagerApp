// lib/features/settings/presentation/widgets/settings_form_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class SettingsFormSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController jobController;
  final TextEditingController regularLeavesController;
  final TextEditingController casualLeavesController;

  const SettingsFormSection({
    super.key,
    required this.nameController,
    required this.jobController,
    required this.regularLeavesController,
    required this.casualLeavesController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('البيانات الشخصية', style: context.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        
        AppTextField(
          label: 'اسم الموظف',
          icon: Icons.person_outline,
          controller: nameController,
          validator: (val) =>
              val == null || val.trim().isEmpty ? 'مطلوب' : null,
        ),
        
        AppTextField(
          label: 'المسمى الوظيفي',
          icon: Icons.work_outline,
          controller: jobController,
          validator: (val) =>
              val == null || val.trim().isEmpty ? 'مطلوب' : null,
        ),
        
        const SizedBox(height: AppSpacing.sm),
        Text('الأرصدة السنويه المستحقة', style: context.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: regularLeavesController,
                builder: (context, value, child) {
                  final currentValue = int.tryParse(value.text) ?? 15;
                  return AppCounterColumn(
                    label: 'إجمالي الاعتيادي',
                    value: currentValue,
                    min: 15,
                    max: 45,
                    onChanged: (newValue) {
                      regularLeavesController.text = newValue.toString();
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: casualLeavesController,
                builder: (context, value, child) {
                  final currentValue = int.tryParse(value.text) ?? 7;
                  return AppCounterColumn(
                    label: 'إجمالي العارضة',
                    value: currentValue,
                    min: 6,
                    max: 7,
                    onChanged: (newValue) {
                      casualLeavesController.text = newValue.toString();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}