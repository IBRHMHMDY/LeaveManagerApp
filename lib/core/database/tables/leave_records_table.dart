import 'package:drift/drift.dart';

@DataClassName('LeaveRecordModel')
@TableIndex(name: 'idx_leave_dates', columns: {#startDate, #endDate})
class LeaveRecordsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get leaveType => integer()(); 
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get daysCount => integer()();
  TextColumn get notes => text().nullable()();
}