import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';

/// مكون عام لاختيار فترة زمنية (من - إلى) يدعم حدود السنة المالية ويمنع التواريخ المستقبلية
class CustomDateRangePickerField extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final String hintText;
  final ValueChanged<DateTimeRange?> onDateSelected;
  
  // حدود السنة المالية التي يتم تمريرها من الميزة المستدعية
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDateRangePickerField({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
    this.hintText = 'اضغط لاختيار الفترة',
  });

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();

    // القاعدة الأساسية: إذا كانت نهاية السنة المالية (lastDate) في المستقبل، 
    // يتم حدّها بتاريخ اليوم لمنع اختيار أي تاريخ مستقبلي.
    DateTime effectiveLastDate = lastDate.isAfter(now) ? now : lastDate;

    // حماية إضافية لتفادي أخطاء الـ SDK في حال كان تاريخ البداية بعد تاريخ اليوم
    if (firstDate.isAfter(effectiveLastDate)) {
      effectiveLastDate = firstDate;
    }

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: effectiveLastDate,
      initialDateRange: startDate != null && endDate != null && startDate != endDate
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      saveText: 'تأكيد',
      cancelText: 'إلغاء',
      helpText: 'اختر الفترة (من - إلى)',
      builder: (context, child) => Theme(
        data: Theme.of(context),
        child: child!,
      ),
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

    // AMD 2026: معالجة منطق النص المنعكس على الواجهة بشكل نظيف
    String displayText = hintText;
    if (hasDate) {
      // التحقق مما إذا كان تاريخ البداية والنهاية هما نفس اليوم
      if (startDate!.isAtSameMomentAs(endDate!)) {
        displayText = startDate!.toFormattedDate();
      } else {
        displayText = '${startDate!.toFormattedDate()}   -   ${endDate!.toFormattedDate()}';
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
          children: [
            Icon(
              Icons.date_range_rounded,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                displayText, // استخدام المتغير النصي المجهز مسبقاً
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: hasDate ? FontWeight.bold : FontWeight.normal,
                  color: hasDate ? colorScheme.primary : colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}