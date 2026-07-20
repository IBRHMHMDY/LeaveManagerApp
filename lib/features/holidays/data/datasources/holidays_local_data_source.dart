import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

abstract class HolidaysLocalDataSource {
  Future<bool> hasHolidays();
  Future<void> seedHolidaysFromJson();
  Future<List<HolidayModel>> getFinancialYearHolidays(DateTime start, DateTime end);
  Future<HolidayModel?> getUpcomingHoliday(DateTime today);
}

@LazySingleton(as: HolidaysLocalDataSource)
class HolidaysLocalDataSourceImpl implements HolidaysLocalDataSource {
  final AppDatabase db;

  HolidaysLocalDataSourceImpl(this.db);

  @override
  Future<bool> hasHolidays() async {
    try {
      final countExp = db.holidaysTable.id.count();
      final query = db.selectOnly(db.holidaysTable)..addColumns([countExp]);
      final result = await query.map((row) => row.read(countExp)).getSingle();
      return (result ?? 0) > 0;
    } catch (e) {
      throw DatabaseException('فشل في التحقق من وجود العطلات');
    }
  }

  @override
  Future<void> seedHolidaysFromJson() async {
    try {
      // قراءة الملف من الـ Assets
      final String jsonString = await rootBundle.loadString('assets/json/holidays.json');
      final List<dynamic> jsonResponse = json.decode(jsonString);

      // تحويل الـ JSON إلى Companion Objects للإدخال المجمع
      final List<HolidaysTableCompanion> holidays = jsonResponse.map((json) {
        return HolidaysTableCompanion.insert(
          name: json['name'],
          startDate: DateTime.parse(json['startDate']),
          endDate: DateTime.parse(json['endDate']),
          daysCount: json['days_count'],
        );
      }).toList();

      // استخدام batch لإدخال البيانات دفعة واحدة لضمان أعلى أداء
      await db.batch((batch) {
        batch.insertAll(db.holidaysTable, holidays);
      });
    } catch (e) {
      debugPrint('❌ JSON Seeding Error: $e');
      throw DatabaseException('فشل في قراءة أو حفظ ملف العطلات');
    }
  }

  @override
  Future<List<HolidayModel>> getFinancialYearHolidays(DateTime start, DateTime end) async {
    try {
      return await (db.select(db.holidaysTable)
            ..where((tbl) => tbl.startDate.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.asc(t.startDate)])) // ترتيب تصاعدي
          .get();
    } catch (e) {
      throw DatabaseException('فشل في جلب عطلات السنة المالية');
    }
  }

  @override
  Future<HolidayModel?> getUpcomingHoliday(DateTime today) async {
    try {
      // جلب أول عطلة لم تنتهِ بعد بناءً على تاريخ اليوم
      final query = db.select(db.holidaysTable)
        ..where((tbl) => tbl.endDate.isBiggerOrEqualValue(today))
        ..orderBy([(t) => OrderingTerm.asc(t.startDate)])
        ..limit(1);
      
      return await query.getSingleOrNull();
    } catch (e) {
      throw DatabaseException('فشل في جلب العطلة القادمة');
    }
  }
}