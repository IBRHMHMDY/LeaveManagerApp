import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  /// يُرجع التاريخ حسب هيئة التاريخ فى جهازك (مثال: 23/7/2026)
  String toFormattedDate() {
    return DateFormat('yyyy-MM-dd', Intl.getCurrentLocale()).format(this);
  }
  /// يُرجع التاريخ كامل مع اسم الشهر (مثال: 23 يوليو 2026)
  String toFullDate() {
    return DateFormat('d MMMM yyyy', Intl.getCurrentLocale()).format(this);
  }
  /// يُرجع التاريخ كامل مع  اسم الشهر واليوم (مثال: الخميس 23 يوليو 2026)
  String toHolidayFormat() {
    return DateFormat('EEEE d MMMM yyyy', 'ar').format(this);
  }

  /// يُرجع اسم الشهر الحالي كاملاً (مثال: "يناير")
  String get currentMonthName {
    return DateFormat('MMMM', 'ar').format(this);
  }

  /// يُرجع اسم الشهر الحالي والسنه (مثال: "يناير 2026")
  String get currentMonthYear {
    return DateFormat('MMMM yyyy', 'ar').format(this);
  }
  /// يُرجع رقم الشهر الحالي (مثال: 1, 2, ... 12)
  int get currentMonthNumber {
    return month;
  }
}