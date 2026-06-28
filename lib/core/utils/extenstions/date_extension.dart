import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  /// تنسيق التاريخ ليصبح مقروءاً وموحداً (مثال: 2023-10-25)
  String toFormattedDate() {
    return DateFormat('yyyy-MM-dd', 'en').format(this);
  }
}