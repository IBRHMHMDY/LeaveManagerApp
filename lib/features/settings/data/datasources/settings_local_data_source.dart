// lib/features/settings/data/datasources/settings_local_data_source.dart
import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class SettingsLocalDataSource {
  Future<bool> hasSettings();
  Future<SettingModel> getSettings();
  Future<void> saveSettings(SettingsTableCompanion companion);
  Future<void> resetBalances();
}

@LazySingleton(as: SettingsLocalDataSource)
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
      throw DatabaseException('حدث خطأ أثناء التحقق من الإعدادات');
    }
  }

  @override
  Future<SettingModel> getSettings() async {
    try {
      return await (db.select(db.settingsTable)..limit(1)).getSingle();
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء جلب الإعدادات');
    }
  }

  @override
  Future<void> saveSettings(SettingsTableCompanion companion) async {
    try {
      await db.into(db.settingsTable).insert(
        companion,
        mode: InsertMode.insertOrReplace,
      );
    } catch (e) {
      debugPrint('Database Error: $e');
      throw DatabaseException('حدث خطأ أثناء حفظ الإعدادات');
    }
  }

  @override
  Future<void> resetBalances() async {
    try {
      // الاعتماد على transaction لمسح الجداول معاً وضمان الأداء وعدم حدوث Memory Leaks
      await db.transaction(() async {
        await db.delete(db.leaveRecordsTable).go();
        await db.delete(db.restAllowancesTable).go();
      });
    } catch (e) {
      throw DatabaseException('حدث خطأ أثناء مسح السجلات');
    }
  }
}