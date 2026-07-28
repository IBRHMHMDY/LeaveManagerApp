// lib/features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class RestAllowancesLocalDataSource {
  Future<void> addOvertimeRecord(OvertimeRecordsTableCompanion companion);
  Future<List<OvertimeRecordModel>> getOvertimeRecords();
  Future<void> updateOvertimeConsumedStatus(int id, bool isConsumed);
  Future<void> deleteOvertimeRecord(int id);
  
  Future<void> addRestAllowance(RestAllowancesTableCompanion companion);
  Future<List<RestAllowanceModel>> getRestAllowances();
  Future<void> deleteRestAllowance(int id);
}

@LazySingleton(as: RestAllowancesLocalDataSource)
class RestAllowancesLocalDataSourceImpl implements RestAllowancesLocalDataSource {
  final AppDatabase db;

  RestAllowancesLocalDataSourceImpl(this.db);

  @override
  Future<void> addOvertimeRecord(OvertimeRecordsTableCompanion companion) async {
    try {
      await db.into(db.overtimeRecordsTable).insert(companion);
    } catch (e, stackTrace) {
      throw DatabaseException('فشل إضافة سجل العمل الإضافي.');
    }
  }

  @override
  Future<List<OvertimeRecordModel>> getOvertimeRecords() async {
    try {
      return await (db.select(db.overtimeRecordsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();
    } catch (e, stackTrace) {
      throw DatabaseException('فشل استرجاع سجلات العمل الإضافي.');
    }
  }

  @override
  Future<void> updateOvertimeConsumedStatus(int id, bool isConsumed) async {
    try {
      await (db.update(db.overtimeRecordsTable)..where((tbl) => tbl.id.equals(id)))
          .write(OvertimeRecordsTableCompanion(isConsumed: Value(isConsumed)));
    } catch (e, stackTrace) {
      throw DatabaseException('فشل تحديث حالة استهلاك العمل الإضافي.');
    }
  }

  @override
  Future<void> deleteOvertimeRecord(int id) async {
    try {
      await (db.delete(db.overtimeRecordsTable)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e, stackTrace) {
      throw DatabaseException('فشل حذف سجل العمل الإضافي.');
    }
  }

  @override
  Future<void> addRestAllowance(RestAllowancesTableCompanion companion) async {
    try {
      await db.into(db.restAllowancesTable).insert(companion);
    } catch (e, stackTrace) {
      throw DatabaseException('فشل إضافة رصيد الراحة المستهلك.');
    }
  }

  @override
  Future<List<RestAllowanceModel>> getRestAllowances() async {
    try {
      return await (db.select(db.restAllowancesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();
    } catch (e, stackTrace) {
      throw DatabaseException('فشل استرجاع أرصدة الراحة المستهلكة.');
    }
  }

  @override
  Future<void> deleteRestAllowance(int id) async {
    try {
      await (db.delete(db.restAllowancesTable)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e, stackTrace) {
      throw DatabaseException('فشل حذف رصيد الراحة المستهلك.');
    }
  }
}