import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' hide // إخفاء للتعارض مع dartz
    Column; 
import '../../../../../core/errors/failures.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../../../core/database/app_database.dart';
import '../../domain/entities/extra_work_day_entity.dart';
import '../../domain/repositories/extra_work_repository.dart';
import '../datasources/extra_work_local_data_source.dart';
import '../models/extra_work_day_mapper.dart';

class ExtraWorkRepositoryImpl implements ExtraWorkRepository {
  final ExtraWorkLocalDataSource localDataSource;

  ExtraWorkRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<ExtraWorkDay>>> getExtraWorkDays() async {
    try {
      final localData = await localDataSource.getExtraWorkDays();
      final extraWorkDays = localData.map((model) => model.toDomain()).toList();
      return Right(extraWorkDays);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ غير متوقع أثناء جلب البيانات'));
    }
  }

  @override
  Future<Either<Failure, Unit>> addExtraWorkDay(DateTime date, String? notes) async {
    try {
      final companion = ExtraWorkDaysTableCompanion(
        date: Value(date),
        notes: Value(notes),
      );
      await localDataSource.addExtraWorkDay(companion);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ أثناء إضافة يوم العمل الإضافي'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExtraWorkDay(int id) async {
    try {
      await localDataSource.deleteExtraWorkDay(id);
      return const Right(unit);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return const Left(DatabaseFailure('حدث خطأ أثناء الحذف'));
    }
  }
}