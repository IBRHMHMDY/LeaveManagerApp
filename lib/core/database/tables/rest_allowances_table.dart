// lib/core/database/tables/rest_allowances_table.dart
import 'package:drift/drift.dart';
import 'package:leave_manager/core/database/tables/overtime_records_table.dart';

@DataClassName('RestAllowanceModel')
@TableIndex(name: 'idx_rest_dates', columns: {#startDate, #endDate})
class RestAllowancesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // 0 = عطلة رسمية, 1 = عمل إضافي
  IntColumn get workReason => integer()(); 
  
  // ربط بدل الراحة بيوم العمل الإضافي كـ مفتاح أجنبي (Foreign Key)
  IntColumn get overtimeId => integer().references(OvertimeRecordsTable, #id)(); 
  
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get daysCount => integer()();
  
  TextColumn get notes => text().nullable()();
}