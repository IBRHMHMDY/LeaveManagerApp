import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_bloc.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/presentation/bloc/extra_work_events.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';

class AddExtraWorkBottomSheet extends StatefulWidget {
  const AddExtraWorkBottomSheet({super.key});

  @override
  State<AddExtraWorkBottomSheet> createState() =>
      _AddExtraWorkBottomSheetState();
}

class _AddExtraWorkBottomSheetState extends State<AddExtraWorkBottomSheet> {
  DateTime? _selectedDate;
  final TextEditingController _notesController = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // تطبيق قاعدة Business Logic في الواجهة أيضاً
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.restAllowanceColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _notesController.dispose(); // منع تسرب الذاكرة (Memory Leak)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      // لرفع النافذة عند ظهور الكيبورد
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تسجيل يوم عمل إضافي',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // اختيار التاريخ
          InkWell(
            onTap: () => _pickDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline.withAlpha(50)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'اختر تاريخ العمل الإضافي'
                        : DateFormat('yyyy/MM/dd', 'ar').format(_selectedDate!),
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedDate == null
                          ? Colors.grey
                          : colorScheme.onSurface,
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today,
                    color: AppColors.restAllowanceColor,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // إدخال الملاحظات
          CustomTextField(
            controller: _notesController,
            label: 'ملاحظات (سبب العمل الإضافي)',
            icon: Icons.notes,
          ),
          const SizedBox(height: 24),

          // زر الحفظ
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.restAllowanceColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (_selectedDate == null) {
                AppNotifications.showWarning(context, 'الرجاء اختيار التاريخ');
                return;
              }
              context.read<ExtraWorkBloc>().add(
                AddExtraWorkDayEvent(
                  date: _selectedDate!,
                  notes: _notesController.text,
                ),
              );
              Navigator.pop(context); // إغلاق النافذة
            },
            child: const Text(
              'حفظ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
