import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';

List<Map<String, dynamic>> _parseJsonInBackground(String jsonString) {
  final decoded = json.decode(jsonString) as List<dynamic>;
  return decoded.cast<Map<String, dynamic>>();
}

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
      // قراءة الملف كنص
      final String jsonString = await rootBundle.loadString('assets/json/holidays.json');
      
      // معالجة الـ JSON في Isolate منفصل لمنع تجميد الشاشة
      final List<Map<String, dynamic>> jsonResponse = await compute(_parseJsonInBackground, jsonString);

      // تحويل البيانات إلى كائنات Drift على الخيط الرئيسي (عملية خفيفة جداً)
      final List<HolidaysTableCompanion> holidays = jsonResponse.map((json) {
        return HolidaysTableCompanion.insert(
          name: json['name'],
          startDate: DateTime.parse(json['startDate']),
          endDate: DateTime.parse(json['endDate']),
          daysCount: json['days_count'],
        );
      }).toList();

      // إدراج البيانات دفعة واحدة (Batch Insert)
      await db.batch((batch) {
        batch.insertAll(db.holidaysTable, holidays);
      });
    } catch (e, stackTrace) {
      debugPrint('JSON Seeding Error: $e\n$stackTrace');
      throw DatabaseException('حدث خطأ أثناء تحميل بيانات الإجازات الأولية.');
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