import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/exceptions.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/network/network_info.dart';
import 'package:leave_manager/features/holidays/data/datasources/holidays_local_data_source.dart';
import 'package:leave_manager/features/holidays/data/datasources/holidays_remote_data_source.dart';
import 'package:leave_manager/features/holidays/data/models/holiday_mapper.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';

@LazySingleton(as: HolidaysRepository)
class HolidaysRepositoryImpl implements HolidaysRepository {
  final HolidaysLocalDataSource localDataSource;
  final HolidaysRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HolidaysRepositoryImpl(
    this.localDataSource,
    this.remoteDataSource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, Unit>> initializeHolidays() async {
    try {
      // إذا كان هناك اتصال بالإنترنت، جلب العطلات وتحديثها محلياً
      if (await networkInfo.isConnected) {
        final remoteData = await remoteDataSource.getHolidays();
        await localDataSource.cacheHolidays(remoteData.data);
      } else {
        // التحقق من وجود عطلات محلية إذا لم يكن هناك إنترنت
        final hasHolidays = await localDataSource.hasHolidays();
        if (!hasHolidays) {
          // يمكن إرجاع تنبيه أنه لا توجد بيانات أصلية
        }
      }
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('حدث خطأ غير متوقع أثناء تهيئة العطلات.'));
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