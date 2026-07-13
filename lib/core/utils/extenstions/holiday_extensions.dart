// lib/features/holidays/domain/extensions/holiday_extensions.dart
import 'package:leave_manager/features/rest_allowance/holidays/domain/entities/holiday_entity.dart';


extension HolidayListExtension on List<Holiday> {
  /// جلب الإجازة الرسمية القادمة الأقرب تاريخياً والتي لم تنتهِ بعد
  Holiday? get nextUpcomingHoliday {
    final now = DateTime.now();
    
    // 1. تصفية القائمة لاستبعاد الإجازات التي انتهت بالفعل (تاريخ النهاية قبل اليوم الحالي)
    final upcomingHolidays = where((holiday) {
      // نقوم بضبط تاريخ نهاية الإجازة ليشمل اليوم كاملاً حتى الساعة 23:59:59
      final endOfHoliday = DateTime(
        holiday.endDate.year,
        holiday.endDate.month,
        holiday.endDate.day,
        23,
        59,
        59,
      );
      return endOfHoliday.isAfter(now);
    }).toList();

    if (upcomingHolidays.isEmpty) return null;

    // 2. ترتيب الإجازات المتبقية تصاعدياً من الأقرب تاريخاً إلى الأبعد
    upcomingHolidays.sort((a, b) => a.startDate.compareTo(b.startDate));

    // 3. إعادة الإجازة الأولى في القائمة المرتبة وهي الأقرب دائماً
    return upcomingHolidays.first;
  }
}