// lib/shared/widgets/inputs/app_date_range_picker.dart
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppDateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String hintText;
  final ValueChanged<DateTimeRange?> onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool Function(DateTime)? selectableDayPredicate;
  final Color? colorIcon;

  const AppDateRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    this.colorIcon,
    this.hintText = 'اختر التاريخ',
    this.selectableDayPredicate,
  });

  Future<void> _pickDateRange(BuildContext context) async {
    // إعدادات المظهر العصري للتقويم
    final config = CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: selectableDayPredicate,
      // 🚀 إخفاء الترويسة المزعجة
      disableModePicker: true, 
      // 🚀 تخصيص الألوان بشكل مريح للعين
      selectedDayHighlightColor: context.colorScheme.primary,
      selectedRangeHighlightColor: context.colorScheme.primary.withOpacity(0.1),
      selectedDayTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      dayTextStyle: context.textTheme.bodyMedium,
      todayTextStyle: context.textTheme.bodyMedium?.copyWith(
        color: context.colorScheme.primary,
        fontWeight: FontWeight.bold,
      ),
      // 🚀 تحسين أزرار التحكم
      cancelButton: Text('إلغاء', style: TextStyle(color: context.colorScheme.error)),
      okButton: Text('تأكيد', style: TextStyle(color: context.colorScheme.primary, fontWeight: FontWeight.bold)),
      centerAlignModePicker: true,
    );

    // 🚀 عرض التقويم داخل BottomSheet عصري بدلاً من Dialog كامل الشاشة
    final values = await showCalendarDatePicker2Dialog(
      context: context,
      config: config,
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.circular(24),
      dialogBackgroundColor: context.colorScheme.surface,
      value: [
        if (startDate != null) startDate!,
        if (endDate != null) endDate!,
      ],
      builder: (context, child) {
        // يمكننا استخدام Theme هنا للتأكد من الخطوط
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (values != null && values.isNotEmpty) {
      final start = values[0];
      final end = values.length > 1 && values[1] != null ? values[1] : start;
      if (start != null && end != null) {
        onDateSelected(DateTimeRange(start: start, end: end));
      }
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
        displayText = '${startDate!.toFormatCurrentLocale()}   -   ${endDate!.toFormatCurrentLocale()}';
      }
    }

    return InkWell(
      onTap: () => _pickDateRange(context),
      borderRadius: AppRadius.md,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: hasDate ? context.colorScheme.primary : Colors.transparent,
            width: hasDate ? 1.5 : 0,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range_rounded, color: colorIcon ?? context.colorScheme.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                displayText,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: hasDate ? FontWeight.bold : FontWeight.normal,
                  color: hasDate
                      ? context.colorScheme.primary
                      : context.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}