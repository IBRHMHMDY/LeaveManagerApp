import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';

abstract class LeavesLocalDataSource {

  Future<void> addLeaveRecord(LeaveRecordsTableCompanion companion);
  Future<List<LeaveRecordModel>> getLeavesBetween(DateTime start, DateTime end);
  

}

class LeavesLocalDataSourceImpl implements LeavesLocalDataSource {
  final AppDatabase db;

  LeavesLocalDataSourceImpl(this.db);


  @override
  Future<void> addLeaveRecord(LeaveRecordsTableCompanion companion) async {
    try {
      await db.into(db.leaveRecordsTable).insert(companion);
    } catch (e) {
      throw DatabaseException('فشل في تسجيل الإجازة');
    }
  }

  @override
  Future<List<LeaveRecordModel>> getLeavesBetween(DateTime start, DateTime end) async {
    try {
      return await (db.select(db.leaveRecordsTable)
            ..where((tbl) => tbl.startDate.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();
    } catch (e) {
      throw DatabaseException('فشل في جلب سجلات الإجازات');
    }
  }

  
}