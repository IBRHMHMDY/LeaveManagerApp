// lib/features/rest_allowances/data/datasources/rest_allowances_local_data_source.dart
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class RestAllowancesLocalDataSource {
  Future<void> addExtraWork(RestAllowancesTableCompanion companion);
  Future<List<RestAllowanceModel>> getAllExtraWork();
  Future<void> useRestAllowance({
    required int id,
    required int usedDaysCount,
    required DateTime restStartDate,
    required DateTime restEndDate,
    String? notes,
  });
  Future<void> deleteExtraWork(int id);
}

@LazySingleton(as: RestAllowancesLocalDataSource)
class RestAllowancesLocalDataSourceImpl implements RestAllowancesLocalDataSource {
  final AppDatabase db;
  RestAllowancesLocalDataSourceImpl(this.db);

  @override
  Future<void> addExtraWork(RestAllowancesTableCompanion companion) async {
    try {
      await db.into(db.restAllowancesTable).insert(companion);
    } catch (e) {
      debugPrint('Database Error: $e');
      throw DatabaseException('حدث خطأ أثناء حفظ السجل.');
    }
  }

  @override
  Future<List<RestAllowanceModel>> getAllExtraWork() async {
    try {
      // نجلب جميع السجلات مرتبة تنازلياً حسب تاريخ العمل
      return await (db.select(db.restAllowancesTable)
            ..orderBy([(t) => OrderingTerm.desc(t.workStartDate)]))
          .get();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء جلب السجلات.');
    }
  }

  @override
  Future<void> useRestAllowance({
    required int id,
    required int usedDaysCount,
    required DateTime restStartDate,
    required DateTime restEndDate,
    String? notes,
  }) async {
    try {
      // استخدام Transaction لضمان تطبيق التقسيم بأمان كامل
      await db.transaction(() async {
        // 1. جلب السجل الأصلي المتاح (availables)
        final original = await (db.select(db.restAllowancesTable)
              ..where((tbl) => tbl.id.equals(id)))
            .getSingle();

        if (original.isUsed) {
          throw DatabaseException('هذا الرصيد تم استخدامه مسبقاً.');
        }

        if (original.daysCount == usedDaysCount) {
          // استهلاك كلي (Usage): تحديث السجل الحالي فقط
          await (db.update(db.restAllowancesTable)
                ..where((tbl) => tbl.id.equals(id)))
              .write(RestAllowancesTableCompanion(
            isUsed: const Value(true),
            restStartDate: Value(restStartDate),
            restEndDate: Value(restEndDate),
            notes: notes != null ? Value(notes) : const Value.absent(),
          ));
        } else if (original.daysCount > usedDaysCount) {
          // استهلاك جزئي: تطبيق نمط (Record Splitting)
          
          // أ) تحويل السجل الأصلي إلى سجل مستهلك (Usage) بالأيام المطلوبة
          await (db.update(db.restAllowancesTable)
                ..where((tbl) => tbl.id.equals(id)))
              .write(RestAllowancesTableCompanion(
            daysCount: Value(usedDaysCount),
            isUsed: const Value(true),
            restStartDate: Value(restStartDate),
            restEndDate: Value(restEndDate),
            notes: notes != null ? Value(notes) : const Value.absent(),
          ));

          // ب) إنشاء سجل جديد بالجزء المتبقي ليعود كرصيد متاح (Availables)
          final remainingDays = original.daysCount - usedDaysCount;
          await db.into(db.restAllowancesTable).insert(
            RestAllowancesTableCompanion.insert(
              workReason: original.workReason,
              workStartDate: original.workStartDate,
              workEndDate: original.workEndDate,
              daysCount: remainingDays,
              isUsed: const Value(false), // لا يزال متاحاً
              holidayId: Value(original.holidayId),
              // حقول تواريخ الراحة تبقى Null تلقائياً
            ),
          );
        } else {
          throw DatabaseException('عدد أيام بدل الراحة المطلوبة يتجاوز الرصيد المتاح.');
        }
      });
    } catch (e) {
      debugPrint('Transaction Error: $e');
      if (e is DatabaseException) rethrow;
      throw DatabaseException('فشل في تحويل الرصيد إلى بدل راحة.');
    }
  }

  @override
  Future<void> deleteExtraWork(int id) async {
    try {
      await (db.delete(db.restAllowancesTable)..where((tbl) => tbl.id.equals(id))).go();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء محاولة الحذف.');
    }
  }
}