// lib/core/utils/financial_year_calculator.dart
import 'package:leave_manager/core/utils/enums/financial_year_type.dart';

abstract class FinancialYearCalculator {
  // الاعتماد على دالة داخلية لجلب الوقت الحالي لتسهيل الـ Mocking في الـ Unit Testing
  static DateTime get _now => DateTime.now();

  /// جلب تاريخ بداية السنة بناءً على نوع السنة المحددة
  static DateTime getYearStart(FinancialYearType type) {
    if (type == FinancialYearType.calendarYear) {
      // السنة الميلادية: تبدأ دائماً في 1 يناير من العام الحالي
      return DateTime(_now.year, 1, 1);
    } else {
      // السنة المالية: تبدأ في 1 يوليو
      if (_now.month >= 7) {
        return DateTime(_now.year, 7, 1);
      } else {
        return DateTime(_now.year - 1, 7, 1);
      }
    }
  }

  /// جلب تاريخ نهاية السنة بناءً على نوع السنة المحددة
  static DateTime getYearEnd(FinancialYearType type) {
    if (type == FinancialYearType.calendarYear) {
      // السنة الميلادية: تنتهي دائماً في 31 ديسمبر من العام الحالي
      return DateTime(_now.year, 12, 31, 23, 59, 59);
    } else {
      // السنة المالية: تنتهي في 30 يونيو
      if (_now.month >= 7) {
        return DateTime(_now.year + 1, 6, 30, 23, 59, 59);
      } else {
        return DateTime(_now.year, 6, 30, 23, 59, 59);
      }
    }
  }

  /// جلب النص المعبر عن السنة (مثال: "2026" للميلادية أو "2025/2026" للمالية)
  static String getYearString(FinancialYearType type) {
    if (type == FinancialYearType.calendarYear) {
      return "${_now.year}";
    } else {
      final startYear = getYearStart(type).year;
      final endYear = getYearEnd(type).year;
      return "$startYear/$endYear";
    }
  }

  /// التحقق مما إذا كان التاريخ يقع ضمن السنة المحددة
  static bool isDateInYear(DateTime date, FinancialYearType type) {
    final start = getYearStart(type);
    final end = getYearEnd(type);

    return (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
           (date.isBefore(end) || date.isAtSameMomentAs(end));
  }
}