import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/holiday_entity.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../datasources/holidays_local_data_source.dart';
import '../../../../core/database/app_database.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  final HolidaysLocalDataSource _localDataSource;

  const HolidayRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<Holiday>>> getHolidaysBetweenDates(DateTime start, DateTime end) async {
    try {
      final models = await _localDataSource.getHolidaysBetweenDates(start, end);
      final holidays = models.map((m) => Holiday(
            id: m.id,
            name: m.name,
            startDate: m.startDate,
            endDate: m.endDate,
          )).toList();
      return Right(holidays);
    } catch (e) {
      return Left(CacheFailure('فشل في جلب الإجازات الرسمية: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addHoliday(Holiday holiday) async {
    try {
      final companion = HolidaysTableCompanion(
        name: Value(holiday.name),
        startDate: Value(holiday.startDate),
        endDate: Value(holiday.endDate),
      );
      await _localDataSource.addHoliday(companion);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('فشل في إضافة الإجازة: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHoliday(int id) async {
    try {
      await _localDataSource.deleteHoliday(id);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('فشل في حذف الإجازة: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearHolidays() async {
    try {
      await _localDataSource.clearHolidays();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure('فشل في مسح الإجازات القديمة: $e'));
    }
  }
}