import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';

abstract class HolidaysLocalDataSource {
  Future<List<HolidayModel>> getHolidaysBetweenDates(DateTime start, DateTime end);
  Future<void> addHoliday(HolidaysTableCompanion holiday);
  Future<void> deleteHoliday(int id);
  Future<void> clearHolidays(); // إضافة دالة المسح
}

class HolidaysLocalDataSourceImpl implements HolidaysLocalDataSource {
  final AppDatabase _database;

  const HolidaysLocalDataSourceImpl(this._database);

  @override
  Future<List<HolidayModel>> getHolidaysBetweenDates(DateTime start, DateTime end) async {
    return await (_database.select(_database.holidaysTable)
          ..where((t) => t.startDate.isSmallerOrEqualValue(end) & t.endDate.isBiggerOrEqualValue(start)))
        .get();
  }

  @override
  Future<void> addHoliday(HolidaysTableCompanion holiday) async {
    await _database.into(_database.holidaysTable).insert(holiday);
  }

  @override
  Future<void> deleteHoliday(int id) async {
    await (_database.delete(_database.holidaysTable)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearHolidays() async {
    // مسح جميع إجازات هذا البلد من الجدول
    await (_database.delete(_database.holidaysTable)).go();
  }
}