import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';

@lazySingleton
class GetUpcomingHolidayUseCase implements BaseUseCase<Holiday?, DateTime> {
  final HolidaysRepository repository;

  GetUpcomingHolidayUseCase(this.repository);

  @override
  Future<Either<Failure, Holiday?>> call(DateTime today) async {
    return await repository.getUpcomingHoliday(today);
  }
}