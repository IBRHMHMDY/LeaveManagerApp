// lib/core/utils/string_extension.dart

extension StringNumberParsing on String {
  /// تحول الأرقام المشرقية (العربية) إلى أرقام غربية (إنجليزية) وتطهر النص ثم تحوله إلى رقم بأمان
  int toIntSafely() {
    String normalized = trim()
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');

    return int.tryParse(normalized) ?? 0;
  }
  
}

///تنسيق الأيام المتبقية بشكل ذكي باللغة العربية
extension RemainingDaysExtension on int {
  String get remainingDaysText {
    if (this == 0) {
      return 'اليوم!';
    } else if (this == 1) {
      return 'غداً';
    } else if (this == 2) {
      return 'بعد يومين';
    } else {
      return 'متبقي $this أيام';
    }
  }
}