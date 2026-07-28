// lib/core/database/tables/rest_allowances_table.dart
import 'package:drift/drift.dart';
import 'package:leave_manager/core/database/tables/holidays_table.dart';

@DataClassName('RestAllowanceModel')
@TableIndex(name: 'idx_extrawork_dates', columns: {#workStartDate, #workEndDate})
class RestAllowancesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // 0 = Holiday, 1 = Overtime
  IntColumn get workReason => integer()(); 
  
  // تواريخ العمل الفعلي (ExtraWork)
  DateTimeColumn get workStartDate => dateTime()();
  DateTimeColumn get workEndDate => dateTime()();
  
  // عدد الأيام لهذا السجل (قد تتغير عند التقسيم)
  IntColumn get daysCount => integer()();
  
  // حالة السجل: 
  // false = availables (رصيد متاح)
  // true = usage (رصيد مستهلك كبدل راحة)
  BoolColumn get isUsed => boolean().withDefault(const Constant(false))();
  
  // تواريخ بدل الراحة (Rest) - تكون Nullable حتى يتم استخدام الرصيد
  DateTimeColumn get restStartDate => dateTime().nullable()();
  DateTimeColumn get restEndDate => dateTime().nullable()();
  
  // معرف العطلة (إن وجد) لمنع تكرار تسجيل نفس العطلة
  IntColumn get holidayId => integer().nullable().references(HolidaysTable, #id)();
  
  TextColumn get notes => text().nullable()();
}