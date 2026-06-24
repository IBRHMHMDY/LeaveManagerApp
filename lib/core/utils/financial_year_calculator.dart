class FinancialYearCalculator {
  // استخدام دالة لجلب الوقت الحالي لسهولة عمل Mocking أثناء الـ Unit Testing
  static DateTime get _now => DateTime.now();

  /// حساب تاريخ بداية السنة المالية الحالية
  static DateTime get currentFinancialYearStart {
    if (_now.month >= 7) {
      // إذا كنا في شهر 7 أو بعده، السنة المالية بدأت في نفس العام الحالي
      return DateTime(_now.year, 7, 1);
    } else {
      // إذا كنا قبل شهر 7، السنة المالية بدأت في العام الماضي
      return DateTime(_now.year - 1, 7, 1);
    }
  }

  /// حساب تاريخ نهاية السنة المالية الحالية
  static DateTime get currentFinancialYearEnd {
    if (_now.month >= 7) {
      // تنتهي في العام القادم
      return DateTime(_now.year + 1, 6, 30, 23, 59, 59);
    } else {
      // تنتهي في نفس العام الحالي
      return DateTime(_now.year, 6, 30, 23, 59, 59);
    }
  }

  /// إرجاع صيغة السنة المالية الحالية (مثال: 2025/2026)
  static String get financialYearString {
    final startYear = currentFinancialYearStart.year;
    final endYear = currentFinancialYearEnd.year;
    return "$startYear/$endYear";
  }

  /// التحقق مما إذا كان تاريخ معين يقع ضمن السنة المالية الحالية
  static bool isDateInCurrentFinancialYear(DateTime date) {
    final start = currentFinancialYearStart;
    final end = currentFinancialYearEnd;
    
    // التأكد من أن التاريخ أكبر من أو يساوي البداية، وأصغر من أو يساوي النهاية
    return (date.isAfter(start) || date.isAtSameMomentAs(start)) && 
           (date.isBefore(end) || date.isAtSameMomentAs(end));
  }
}