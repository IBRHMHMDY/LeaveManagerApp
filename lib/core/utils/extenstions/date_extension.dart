import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  /// يُرجع التاريخ حسب هيئة التاريخ فى جهازك (مثال: 23-07-2026)
  String toFormatCurrentLocale() {
    return DateFormat('yyyy-MM-dd', Intl.getCurrentLocale()).format(this);
  }

  /// يُرجع التاريخ كامل مع اسم الشهر واليوم (مثال: الخميس 23 يوليو 2026)
  String toFormatFullDaysDate() {
    return DateFormat('EEEE d MMMM yyyy', 'ar').format(this);
  }

  /// يُرجع اسم الشهر الحالي والسنه (مثال: "يوليو 2026")
  String get toFormatCurrentMonthYear {
    return DateFormat('MMMM yyyy', 'ar').format(this);
  }

  /// يُرجع التاريخ بصيغة يوم/شهر (مثال: 25/7)
  String toFormatDayMonth() => '$day/$month';

  /// يُرجع التاريخ بصيغة يوم/شهر/سنة (مثال: 25/7/2026)
  String toFormatFull() => '$day/$month/$year';

  /// يُرجع نطاق زمني بين تاريخين بصيغة ذكية بناءً على المعامل [short]
  String toDateRangeString(DateTime end, {bool short = false}) {
    // this تشير إلى كائن الـ DateTime الحالي الذي نستدعي منه الدالة (startDate)
    if (isAtSameMomentAs(end)) {
      return short ? toFormatDayMonth() : toFormatFull();
    }
    return short
        ? '${toFormatDayMonth()} - ${end.toFormatDayMonth()}'
        : '${toFormatFull()} - ${end.toFormatFull()}';
  }
}