import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/extra_work_day_entity.dart';

abstract class ExtraWorkRepository {
  Future<Either<Failure, List<ExtraWorkDay>>> getExtraWorkDays();
  Future<Either<Failure, Unit>> addExtraWorkDay(DateTime date, String? notes);
  Future<Either<Failure, Unit>> deleteExtraWorkDay(int id);
}