import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';

// كلاس مساعد لتمرير بارامترين لحالة الاستخدام
class DateRangeParams {
  final DateTime start;
  final DateTime end;
  DateRangeParams({required this.start, required this.end});
}

@lazySingleton
class GetFinancialYearHolidaysUseCase implements BaseUseCase<List<Holiday>, DateRangeParams> {
  final HolidaysRepository repository;

  GetFinancialYearHolidaysUseCase(this.repository);

  @override
  Future<Either<Failure, List<Holiday>>> call(DateRangeParams params) async {
    return await repository.getFinancialYearHolidays(params.start, params.end);
  }
}