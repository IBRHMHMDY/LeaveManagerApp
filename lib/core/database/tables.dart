import 'package:drift/drift.dart';

@DataClassName('SettingModel')
class SettingsTable extends Table {
  IntColumn get id => integer()(); // المُعرف
  TextColumn get employeeName => text()();
  TextColumn get jobTitle => text()();
  IntColumn get totalRegularLeaves => integer()();
  IntColumn get totalCasualLeaves => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LeaveRecordModel')
class LeaveRecordsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get leaveType => integer()(); // 0: Regular, 1: Casual
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get daysCount => integer()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('HolidayModel')
class HolidaysTable extends Table {
  IntColumn get id => integer().autoIncrement()(); // المُعرف
  TextColumn get name => text()(); // اسم الإجازة
  DateTimeColumn get startDate => dateTime()(); // تاريخ البداية
  DateTimeColumn get endDate => dateTime()(); // تاريخ النهاية
}