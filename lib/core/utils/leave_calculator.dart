
import 'package:leave_manager/features/rest_allowance/holidays/domain/entities/holiday_entity.dart';

class LeaveCalculator {
  /// تحسب هذه الدالة عدد أيام الإجازة الفعلية
  /// وتقوم باستبعاد الأيام التي تقع ضمن الإجازات الرسمية المسجلة.
  static int calculateActualLeaveDays({
    required DateTime startDate,
    required DateTime endDate,
    required List<Holiday> officialHolidays,
  }) {
    int count = 0;
    
    // إرجاع وقت التواريخ لمنتصف الليل لضمان دقة المقارنة
    DateTime current = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(end)) {
      bool isHoliday = false;

      for (var holiday in officialHolidays) {
        final hStart = DateTime(holiday.startDate.year, holiday.startDate.month, holiday.startDate.day);
        final hEnd = DateTime(holiday.endDate.year, holiday.endDate.month, holiday.endDate.day);

        // إذا كان اليوم الحالي يقع ضمن نطاق إجازة رسمية
        if ((current.isAtSameMomentAs(hStart) || current.isAfter(hStart)) &&
            (current.isAtSameMomentAs(hEnd) || current.isBefore(hEnd))) {
          isHoliday = true;
          break;
        }
      }

      // إذا لم يكن اليوم إجازة رسمية، أضفه للرصيد المسحوب
      if (!isHoliday) {
        count++;
      }

      // الانتقال لليوم التالي
      current = current.add(const Duration(days: 1));
    }

    return count;
  }
}