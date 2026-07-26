import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class RestAllowancesLocalDataSource {
  Future<void> addRestAllowance(RestAllowancesTableCompanion companion);
  Future<List<RestAllowanceModel>> getRestAllowances();
  Future<void> deleteRestAllowance(int id);
}

@LazySingleton(as: RestAllowancesLocalDataSource)
class RestAllowancesLocalDataSourceImpl implements RestAllowancesLocalDataSource {
  final AppDatabase db;

  RestAllowancesLocalDataSourceImpl(this.db);

  @override
  Future<void> addRestAllowance(RestAllowancesTableCompanion companion) async {
    try {
      await db.into(db.restAllowancesTable).insert(companion);
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء إضافة سجل بدل الراحة.');
    }
  }

  @override
  Future<List<RestAllowanceModel>> getRestAllowances() async {
    try {
      // جلب جميع السجلات مرتبة تنازلياً حسب تاريخ البداية
      return await (db.select(db.restAllowancesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء استرجاع بدلات الراحة.');
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