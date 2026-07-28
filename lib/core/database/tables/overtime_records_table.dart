// lib/core/database/tables/overtime_records_table.dart
import 'package:drift/drift.dart';
import 'package:leave_manager/core/database/tables/holidays_table.dart';

@DataClassName('OvertimeRecordModel')
@TableIndex(name: 'idx_overtime_dates', columns: {#startDate, #endDate})
class OvertimeRecordsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // 0 = عطلة رسمية, 1 = عمل إضافي
  IntColumn get workReason => integer()(); 
  
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get daysCount => integer()();
  IntColumn get holidayId => integer().nullable().references(HolidaysTable, #id)();
  // لتتبع ما إذا كان الرصيد تم استهلاكه بالكامل
  BoolColumn get isConsumed => boolean().withDefault(const Constant(false))(); 
  
  TextColumn get notes => text().nullable()();
}