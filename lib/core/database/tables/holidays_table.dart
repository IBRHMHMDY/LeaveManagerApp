import 'package:drift/drift.dart';

@DataClassName('HolidayModel')
@TableIndex(name: 'idx_holiday_dates', columns: {#startDate, #endDate})
class HolidaysTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get daysCount => integer()();
}