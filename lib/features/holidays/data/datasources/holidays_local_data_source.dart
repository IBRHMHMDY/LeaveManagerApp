import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/features/holidays/data/models/holiday_dto.dart';

abstract class HolidaysLocalDataSource {
  Future<bool> hasHolidays();
  Future<void> cacheHolidays(List<HolidayDto> holidays);
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
      throw const DatabaseException('فشل في التحقق من وجود عطلات.');
    }
  }

  @override
  Future<void> cacheHolidays(List<HolidayDto> holidays) async {
    try {
      final List<HolidaysTableCompanion> companions = holidays.map((dto) {
        return HolidaysTableCompanion.insert(
          id: Value(dto.id),
          name: dto.name,
          startDate: dto.startDate,
          endDate: dto.endDate,
          daysCount: dto.daysCount,
        );
      }).toList();

      await db.batch((batch) {
        batch.insertAll(
          db.holidaysTable, 
          companions, 
          mode: InsertMode.insertOrReplace
        );
      });
    } catch (e, stackTrace) {
      debugPrint('Caching Holidays Error: $e\n$stackTrace');
      throw const DatabaseException('حدث خطأ أثناء حفظ العطلات محلياً.');
    }
  }

  @override
  Future<List<HolidayModel>> getFinancialYearHolidays(DateTime start, DateTime end) async {
    try {
      return await (db.select(db.holidaysTable)
            ..where((tbl) => tbl.startDate.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
          .get();
    } catch (e) {
      throw const DatabaseException('فشل في جلب عطلات السنة المالية.');
    }
  }

  @override
  Future<HolidayModel?> getUpcomingHoliday(DateTime today) async {
    try {
      final query = db.select(db.holidaysTable)
        ..where((tbl) => tbl.endDate.isBiggerOrEqualValue(today))
        ..orderBy([(t) => OrderingTerm.asc(t.startDate)])
        ..limit(1);
      return await query.getSingleOrNull();
    } catch (e) {
      throw const DatabaseException('فشل في جلب العطلة القادمة.');
    }
  }
}