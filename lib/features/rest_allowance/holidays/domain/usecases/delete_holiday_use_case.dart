import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowance/holidays/domain/repositories/holiday_repository.dart';


class DeleteHolidayUseCase {
  final HolidayRepository repository;

  const DeleteHolidayUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deleteHoliday(id);
  }
}