import 'package:drift/drift.dart';

@DataClassName('RestAllowanceModel')
class RestAllowancesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  // تاريخ العمل الإضافي الذي تم كسب الراحة فيه
  DateTimeColumn get earnedDate => dateTime()();
  // تاريخ أخذ الإجازة كبدل راحة (Nullable لأنه قد يكون غير مستهلك بعد)
  DateTimeColumn get consumedDate => dateTime().nullable()();
  // ملاحظات اختيارية
  TextColumn get notes => text().nullable()();
}