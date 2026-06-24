import 'package:drift/drift.dart';
import 'package:flutter/rendering.dart';
import '../database/app_database.dart';
import '../../core/errors/exceptions.dart';

abstract class LocalDataSource {
  Future<bool> hasSettings();
  Future<SettingModel> getSettings();
  Future<void> saveSettings(SettingsTableCompanion companion);
  Future<void> addLeaveRecord(LeaveRecordsTableCompanion companion);
  Future<List<LeaveRecordModel>> getLeavesBetween(DateTime start, DateTime end);
}

class LocalDataSourceImpl implements LocalDataSource {
  final AppDatabase db;

  LocalDataSourceImpl(this.db);

  @override
  Future<bool> hasSettings() async {
    try {
      final countExp = db.settingsTable.id.count();
      final query = db.selectOnly(db.settingsTable)..addColumns([countExp]);
      final result = await query.map((row) => row.read(countExp)).getSingle();
      return (result ?? 0) > 0;
    } catch (e) {
      throw DatabaseException('فشل في التحقق من وجود الإعدادات');
    }
  }

  @override
  Future<SettingModel> getSettings() async {
    try {
      return await (db.select(db.settingsTable)..limit(1)).getSingle();
    } catch (e) {
      throw DatabaseException('فشل في جلب بيانات الإعدادات');
    }
  }

  @override
  Future<void> saveSettings(SettingsTableCompanion companion) async {
    try {
      // استخدام insertOrReplace بدلاً من insertOnConflictUpdate لضمان التوافق مع كافة الأجهزة
      await db.into(db.settingsTable).insert(
        companion,
        mode: InsertMode.insertOrReplace,
      );
    } catch (e) {
      // يفضل طباعة الخطأ لتسهيل تتبعه أثناء التطوير
      debugPrint('Database Error: $e');
      throw DatabaseException('فشل في حفظ الإعدادات');
    }
  }

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