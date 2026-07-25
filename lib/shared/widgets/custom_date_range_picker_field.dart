// lib/shared/widgets/custom_date_range_picker_field.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';

class CustomDateRangePickerField extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String hintText;
  final ValueChanged<DateTimeRange?> onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool Function(DateTime)? selectableDayPredicate;

  const CustomDateRangePickerField({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    this.hintText = 'اختر التاريخ',
    this.selectableDayPredicate,
  });

  Future<void> _pickDateRange(BuildContext context) async {
    // إزالة القيد الذي كان يجبر effectiveLastDate على أن يكون DateTime.now()
    DateTime effectiveLastDate = lastDate;

    // حماية إضافية من الـ SDK لمنع الأخطاء في حال كان التاريخ الأول بعد الأخير
    if (firstDate.isAfter(effectiveLastDate)) {
      effectiveLastDate = firstDate;
    }

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: effectiveLastDate,
      selectableDayPredicate: selectableDayPredicate == null ? null : (day, start, end) => selectableDayPredicate!(day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange:
          startDate != null && endDate != null && startDate != endDate
              ? DateTimeRange(start: startDate!, end: endDate!)
              : null,
      saveText: 'تأكيد الاختيار',
      cancelText: 'إلغاء',
      helpText: 'اختر فتره الاجازه (من - الى)',
      builder: (context, child) =>
          Theme(data: Theme.of(context), child: child!),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;
    final fillColor = isDark ? Colors.black12 : Colors.grey.shade50;

    final hasDate = startDate != null && endDate != null;
    String displayText = hintText;

    if (hasDate) {
      if (startDate!.isAtSameMomentAs(endDate!)) {
        displayText = startDate!.toFormatCurrentLocale();
      } else {
        displayText =
            '${startDate!.toFormatCurrentLocale()}   -   ${endDate!.toFormatCurrentLocale()}';
      }
    }

    return InkWell(
      onTap: () => _pickDateRange(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasDate ? colorScheme.primary : borderColor,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.date_range_rounded, color: colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText,

                style: TextStyle(
                  fontSize: 16,
                  fontWeight: hasDate ? FontWeight.bold : FontWeight.normal,
                  color: hasDate
                      ? colorScheme.primary
                      : colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}