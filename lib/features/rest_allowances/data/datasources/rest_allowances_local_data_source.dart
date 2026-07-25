import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class RestAllowancesLocalDataSource {
  Future<void> addRestAllowance(RestAllowancesTableCompanion companion);
  Future<List<RestAllowanceModel>> getRestAllowances();
  Future<void> updateRestAllowance(RestAllowancesTableCompanion companion);
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
      throw DatabaseException('حدث خطأ أثناء حفظ كسب الراحة.');
    }
  }

  @override
  Future<List<RestAllowanceModel>> getRestAllowances() async {
    try {
      // جلب جميع الراحات مرتبة تنازلياً حسب تاريخ الكسب
      return await (db.select(db.restAllowancesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.earnedDate)]))
          .get();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء استرجاع بدلات الراحة.');
    }
  }

  @override
  Future<void> updateRestAllowance(RestAllowancesTableCompanion companion) async {
    try {
     await (db.update(db.restAllowancesTable)
            ..where((tbl) => tbl.id.equals(companion.id.value)))
          .write(companion);
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء تحديث بدل الراحة.');
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