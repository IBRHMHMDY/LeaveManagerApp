import 'package:drift/drift.dart';

@DataClassName('SettingModel')
class SettingsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get employeeName => text()();
  TextColumn get jobTitle => text()();
  IntColumn get totalRegularLeaves => integer()();
  IntColumn get totalCasualLeaves => integer()();
  IntColumn get totalSickLeaves => integer().withDefault(const Constant(0))();
  // <-- العمود الجديد: 0 = calendarYear, 1 = fiscalYear
  IntColumn get financialYearType => integer().withDefault(const Constant(1))();
  @override
  Set<Column> get primaryKey => {id};
}