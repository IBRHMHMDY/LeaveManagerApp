import 'package:intl/intl.dart';

extension DateFormatting on DateTime {
  String toFormattedDate() {
    return DateFormat('yyyy-MM-dd', Intl.getCurrentLocale()).format(this);
  }
 
  String toFullDate() {
    return DateFormat('d MMMM yyyy', Intl.getCurrentLocale()).format(this);
  }
}