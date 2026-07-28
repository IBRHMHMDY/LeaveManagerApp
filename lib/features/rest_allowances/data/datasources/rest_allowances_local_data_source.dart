// lib/features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class RestAllowancesLocalDataSource {
  // عمليات العمل الإضافي
  Future<void> addOvertimeRecord(OvertimeRecordsTableCompanion companion);
  Future<List<OvertimeRecordModel>> getOvertimeRecords();
  Future<void> updateOvertimeConsumedStatus(int id, bool isConsumed);
  Future<void> deleteOvertimeRecord(int id);

  // عمليات بدلات الراحة
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
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء إضافة سجل العمل الإضافي.');
    }
  }

  @override
  Future<List<OvertimeRecordModel>> getOvertimeRecords() async {
    try {
      return await (db.select(db.overtimeRecordsTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء جلب سجلات العمل الإضافي.');
    }
  }

  @override
  Future<void> updateOvertimeConsumedStatus(int id, bool isConsumed) async {
    try {
      await (db.update(db.overtimeRecordsTable)..where((tbl) => tbl.id.equals(id)))
          .write(OvertimeRecordsTableCompanion(isConsumed: Value(isConsumed)));
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء تحديث حالة العمل الإضافي.');
    }
  }

  @override
  Future<void> deleteOvertimeRecord(int id) async {
    try {
      await (db.delete(db.overtimeRecordsTable)..where((tbl) => tbl.id.equals(id))).go();
      // ملاحظة: سيتم حذف بدلات الراحة المرتبطة تلقائياً إذا كان مفعل الكاسكيد في قاعدة البيانات أو يجب حذفها برمجياً
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء حذف سجل العمل الإضافي.');
    }
  }

  @override
  Future<void> addRestAllowance(RestAllowancesTableCompanion companion) async {
    try {
      await db.into(db.restAllowancesTable).insert(companion);
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء إضافة بدل الراحة.');
    }
  }

  @override
  Future<List<RestAllowanceModel>> getRestAllowances() async {
    try {
      return await (db.select(db.restAllowancesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء جلب سجلات بدلات الراحة.');
    }
  }

  @override
  Future<void> deleteRestAllowance(int id) async {
    try {
      await (db.delete(db.restAllowancesTable)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء حذف بدل الراحة.');
    }
  }
}