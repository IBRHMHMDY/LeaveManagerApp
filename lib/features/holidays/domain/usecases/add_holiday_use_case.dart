import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holiday_repository.dart';


class AddHolidayUseCase {
  final HolidayRepository repository;

  const AddHolidayUseCase(this.repository);

  Future<Either<Failure, Unit>> call(Holiday holiday) async {
    return await repository.addHoliday(holiday);
  }
}