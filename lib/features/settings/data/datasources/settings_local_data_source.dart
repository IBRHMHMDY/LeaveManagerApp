import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:vacation_tracker/core/database/app_database.dart';
import 'package:vacation_tracker/core/errors/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<bool> hasSettings();
  Future<SettingModel> getSettings();
  Future<void> saveSettings(SettingsTableCompanion companion);
  Future<void> resetBalances();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final AppDatabase db;

  SettingsLocalDataSourceImpl(this.db);

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
  Future<void> resetBalances() async {
    try {
      await db.delete(db.leaveRecordsTable).go();
    } catch (e) {
      throw DatabaseException('فشل في مسح سجلات الإجازات');
    }
  }
}