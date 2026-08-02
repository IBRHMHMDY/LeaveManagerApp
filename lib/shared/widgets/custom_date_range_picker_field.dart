import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class CustomDateRangePickerField extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String hintText;
  final ValueChanged<DateTimeRange?> onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool Function(DateTime)? selectableDayPredicate;
  final Color? colorIcon;

  const CustomDateRangePickerField({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    this.colorIcon,
    this.hintText = 'اختر نطاق التاريخ',
    this.selectableDayPredicate,
  });

  Future<void> _pickDateRange(BuildContext context) async {
    DateTime effectiveLastDate = lastDate;
    if (firstDate.isAfter(effectiveLastDate)) {
      effectiveLastDate = firstDate;
    }

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: effectiveLastDate,
      selectableDayPredicate: selectableDayPredicate == null
          ? null
          : (day, start, end) => selectableDayPredicate!(day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange:
          startDate != null && endDate != null && startDate != endDate
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      saveText: 'تأكيد الاختيار',
      cancelText: 'إلغاء',
      helpText: 'تحديد نطاق التاريخ',
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      borderRadius: AppRadii.md,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: AppRadii.md,
          border: Border.all(
            color: hasDate ? context.colorScheme.primary : Colors.transparent,
            width: hasDate ? 1.5 : 0,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range_rounded, color: colorIcon),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                displayText,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: hasDate ? FontWeight.bold : FontWeight.normal,
                  color: hasDate
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
