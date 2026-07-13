// lib/features/holidays/presentation/widgets/add_holiday_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/shared/widgets/custom_text_field.dart';
import 'package:leave_manager/core/utils/app_notifications.dart';

import '../../holidays/domain/entities/holiday_entity.dart';
import '../../holidays/presentation/bloc/holidays_bloc.dart';
import '../../holidays/presentation/bloc/holidays_event.dart';

class AddHolidayBottomSheet extends StatefulWidget {
  final HolidaysBloc bloc;

  const AddHolidayBottomSheet({super.key, required this.bloc});

  @override
  State<AddHolidayBottomSheet> createState() => _AddHolidayBottomSheetState();
}

class _AddHolidayBottomSheetState extends State<AddHolidayBottomSheet> {
  final _nameController = TextEditingController();
  DateTimeRange? _selectedDateRange;

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      initialDateRange: _selectedDateRange,
      saveText: 'حفظ',
      cancelText: 'إلغاء',
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty || _selectedDateRange == null) {
      AppNotifications.showWarning(context, 'يرجى إدخال اسم الإجازة وتحديد التاريخ.');
      return;
    }

    final newHoliday = Holiday(
      id: 0,
      name: _nameController.text.trim(),
      startDate: _selectedDateRange!.start,
      endDate: _selectedDateRange!.end,
    );

    widget.bloc.add(AddHolidayEvent(newHoliday));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final fillColor = isDark ? Colors.black12 : Colors.grey.shade50;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          Row(
            children: [
              Icon(Icons.event_rounded, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'إضافة إجازة رسمية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          CustomTextField(
            label: 'اسم الإجازة',
            icon: Icons.title_rounded,
            controller: _nameController,
          ),

          InkWell(
            onTap: _pickDateRange,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _selectedDateRange != null ? colorScheme.primary : borderColor,
                  width: _selectedDateRange != null ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range_rounded,
                    color: _selectedDateRange != null ? colorScheme.primary : colorScheme.onSurface.withAlpha(150),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _selectedDateRange == null
                          ? 'حدد فترة الإجازة'
                          : '${_selectedDateRange!.start.toFormattedDate()}  إلى  ${_selectedDateRange!.end.toFormattedDate()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: _selectedDateRange != null ? FontWeight.bold : FontWeight.normal,
                        color: _selectedDateRange != null ? colorScheme.primary : colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _submit,
            child: const Text(
              'حفظ الإجازة',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}