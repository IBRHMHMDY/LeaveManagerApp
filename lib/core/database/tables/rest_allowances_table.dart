import 'package:drift/drift.dart';

@DataClassName('RestAllowanceModel')
class RestAllowancesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => integer()(); // نوع الحركة: 0 = بدل مكتسب (Earned)، 1 = استهلاك (Consumed)
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  DateTimeColumn get linkedEarnedDate => dateTime().nullable()();
  IntColumn get daysCount => integer()();
  TextColumn get notes => text().nullable()();
}