import 'package:flutter/material.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/core/utils/extenstions/string_extension.dart';

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
        const Text(
          'البيانات الشخصية',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 16),
        const Text(
          'الأرصدة السنوية المستحقة',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
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
            const SizedBox(width: 16),
            Expanded(
              child: CustomTextField(
                label: 'إجمالي العارضة',
                icon: Icons.event_busy,
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