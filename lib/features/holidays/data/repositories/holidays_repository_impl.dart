import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/holidays/data/datasources/holidays_local_data_source.dart';
import 'package:leave_manager/features/holidays/data/models/holiday_mapper.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';

@LazySingleton(as: HolidaysRepository)
class HolidaysRepositoryImpl implements HolidaysRepository {
  final HolidaysLocalDataSource localDataSource;

  HolidaysRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, Unit>> initializeHolidays() async {
    try {
      final hasHolidays = await localDataSource.hasHolidays();
      // إذا كان الجدول فارغاً، نقوم بقرائته من ملف json وحفظه
      if (!hasHolidays) {
        await localDataSource.seedHolidaysFromJson();
      }
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع أثناء تهيئة العطلات'));
    }
  }

  @override
  Future<Either<Failure, Holiday?>> getUpcomingHoliday(DateTime today) async {
    try {
      final model = await localDataSource.getUpcomingHoliday(today);
      return Right(model?.toDomain());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Holiday>>> getFinancialYearHolidays(DateTime start, DateTime end) async {
    try {
      final models = await localDataSource.getFinancialYearHolidays(start, end);
      return Right(models.map((model) => model.toDomain()).toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}