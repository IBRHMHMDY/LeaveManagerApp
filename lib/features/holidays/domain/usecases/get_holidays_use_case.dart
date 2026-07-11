import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holiday_repository.dart';

class GetHolidaysUseCase {
  final HolidayRepository repository;

  const GetHolidaysUseCase(this.repository);

  Future<Either<Failure, List<Holiday>>> call(DateTime start, DateTime end) async {
    return await repository.getHolidaysBetweenDates(start, end);
  }
}