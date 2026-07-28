// lib/core/usecases/check_date_overlap_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';

class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;
  final bool allowHolidayOverlap; // 1. أضفنا هذا المتغير

  DateRangeParams({
    required this.startDate, 
    required this.endDate, 
    this.allowHolidayOverlap = false,
  });
}

@lazySingleton
class CheckDateOverlapUseCase implements BaseUseCase<Unit, DateRangeParams> {
  final LeaveRepository leaveRepository;
  final RestAllowancesRepository restAllowancesRepository;
  final HolidaysRepository holidaysRepository;

  CheckDateOverlapUseCase({
    required this.leaveRepository,
    required this.restAllowancesRepository,
    required this.holidaysRepository,
  });

  @override
  Future<Either<Failure, Unit>> call(DateRangeParams params) async {
    final results = await Future.wait([
      leaveRepository.getLeavesBetweenDates(params.startDate, params.endDate),
      restAllowancesRepository.getOvertimeRecords(),
      restAllowancesRepository.getRestAllowances(),
      holidaysRepository.getFinancialYearHolidays(
        FinancialYearCalculator.currentFinancialYearStart,
        FinancialYearCalculator.currentFinancialYearEnd
      ),
    ]);

    final leavesRes = results[0] as Either<Failure, List<LeaveRecord>>;
    final leaves = leavesRes.getOrElse(() => <LeaveRecord>[]);
    for (var leave in leaves) {
      if (_isOverlapping(params.startDate, params.endDate, leave.startDate, leave.endDate)) {
        return const Left(ValidationFailure('تاريخ البداية أو النهاية يتقاطع مع إجازة مسجلة.'));
      }
    }

    final overtimesRes = results[1] as Either<Failure, List<OvertimeRecord>>;
    final overtimes = overtimesRes.getOrElse(() => <OvertimeRecord>[]);
    for (var overtime in overtimes) {
      if (_isOverlapping(params.startDate, params.endDate, overtime.startDate, overtime.endDate)) {
        return const Left(ValidationFailure('تاريخ البداية أو النهاية يتقاطع مع رصيد عمل إضافي مسجل.'));
      }
    }

    final restsRes = results[2] as Either<Failure, List<RestAllowance>>;
    final rests = restsRes.getOrElse(() => <RestAllowance>[]);
    for (var rest in rests) {
      if (_isOverlapping(params.startDate, params.endDate, rest.startDate, rest.endDate)) {
        return const Left(ValidationFailure('تاريخ البداية أو النهاية يتقاطع مع بدل راحة مسجل.'));
      }
    }

    // 2. التحقق من العطلات فقط إذا لم يُسمح بالتداخل
    if (!params.allowHolidayOverlap) {
      final holidaysRes = results[3] as Either<Failure, List<Holiday>>;
      final holidays = holidaysRes.getOrElse(() => <Holiday>[]);
      for (var holiday in holidays) {
        if (_isOverlapping(params.startDate, params.endDate, holiday.startDate, holiday.endDate)) {
          return const Left(ValidationFailure('تاريخ البداية أو النهاية يتقاطع مع عطلة رسمية.'));
        }
      }
    }

    return const Right(unit);
  }

  bool _isOverlapping(DateTime s1, DateTime e1, DateTime s2, DateTime e2) {
    final start1 = DateTime(s1.year, s1.month, s1.day);
    final end1 = DateTime(e1.year, e1.month, e1.day);
    final start2 = DateTime(s2.year, s2.month, s2.day);
    final end2 = DateTime(e2.year, e2.month, e2.day);
    return !start1.isAfter(end2) && !end1.isBefore(start2);
  }
}