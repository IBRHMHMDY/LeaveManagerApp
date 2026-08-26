import 'package:drift/drift.dart';

@DataClassName('SettingModel')
class SettingsTable extends Table {
  IntColumn get id => integer()();
  TextColumn get employeeName => text()();
  TextColumn get jobTitle => text()();
  IntColumn get totalRegularLeaves => integer()();
  IntColumn get totalCasualLeaves => integer()();
  BoolColumn get enableNotifications => boolean().withDefault(const Constant(true))(); 
  
  @override
  Set<Column> get primaryKey => {id};
}