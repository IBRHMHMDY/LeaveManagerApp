// lib/features/settings/presentation/widgets/settings_form_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/string_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';

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

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'مطلوب';
    if (value.toIntSafely() == 0 &&
        value.trim() != '0' &&
        value.trim() != '٠') {
      return 'أرقام فقط';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'البيانات الشخصية',
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: AppSpacing.md),
        CustomTextField(
          label: 'اسم الموظف',
          icon: Icons.person_outline,
          controller: nameController,
          validator: (val) => val == null || val.trim().isEmpty ? 'مطلوب' : null,
        ),
        CustomTextField(
          label: 'المسمى الوظيفي',
          icon: Icons.work_outline,
          controller: jobController,
          validator: (val) => val == null || val.trim().isEmpty ? 'مطلوب' : null,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'الأرصدة السنويه المستحقة',
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: 'إجمالي الاعتيادي',
                icon: Icons.event_available,
                controller: regularLeavesController,
                keyboardType: TextInputType.number,
                validator: _numberValidator,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: CustomTextField(
                label: 'إجمالي العارضة',
                icon: Icons.event_available,
                controller: casualLeavesController,
                keyboardType: TextInputType.number,
                validator: _numberValidator,
              ),
            ),
          ],
        ),
      ],
    );
  }
}