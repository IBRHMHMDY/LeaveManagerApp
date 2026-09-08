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
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';

class DateRangeParams {
  final DateTime startDate;
  final DateTime endDate;
  final bool allowHolidayOverlap;

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
  final GetSettingsUseCase getSettings; // <-- تم الحقن

  CheckDateOverlapUseCase({
    required this.leaveRepository,
    required this.restAllowancesRepository,
    required this.holidaysRepository,
    required this.getSettings,
  });

  @override
  Future<Either<Failure, Unit>> call(DateRangeParams params) async {
    // 1. جلب الإعدادات
    final settingsResult = await getSettings(const NoParams());
    if (settingsResult.isLeft()) {
      return Left(settingsResult.fold((l) => l, (r) => throw Exception()));
    }
    
    final settings = settingsResult.getOrElse(() => throw Exception());
    final startYear = FinancialYearCalculator.getYearStart(settings.financialYearType);
    final endYear = FinancialYearCalculator.getYearEnd(settings.financialYearType);

    // 2. فحص التداخل
    final results = await Future.wait([
      leaveRepository.getLeavesBetweenDates(params.startDate, params.endDate),
      restAllowancesRepository.getAllExtraWork(),
      holidaysRepository.getFinancialYearHolidays(startYear, endYear),
    ]);

    final leavesRes = results[0] as Either<Failure, List<LeaveRecord>>;
    final leaves = leavesRes.getOrElse(() => <LeaveRecord>[]);
    for (var leave in leaves) {
      if (_isOverlapping(params.startDate, params.endDate, leave.startDate, leave.endDate)) {
        return const Left(ValidationFailure('يوجد تداخل مع إجازة مسجلة بالفعل.'));
      }
    }

    final extraWorkRes = results[1] as Either<Failure, List<ExtraWorkRecord>>;
    final extraWorks = extraWorkRes.getOrElse(() => <ExtraWorkRecord>[]);
    for (var record in extraWorks) {
      if (_isOverlapping(params.startDate, params.endDate, record.workStartDate, record.workEndDate)) {
        return const Left(ValidationFailure('يوجد تداخل مع عمل إضافي مسجل.'));
      }
      if (record.isUsed && record.restStartDate != null && record.restEndDate != null) {
        if (_isOverlapping(params.startDate, params.endDate, record.restStartDate!, record.restEndDate!)) {
          return const Left(ValidationFailure('يوجد تداخل مع رصيد راحة مستخدم.'));
        }
      }
    }

    if (!params.allowHolidayOverlap) {
      final holidaysRes = results[2] as Either<Failure, List<Holiday>>;
      final holidays = holidaysRes.getOrElse(() => <Holiday>[]);
      for (var holiday in holidays) {
        if (_isOverlapping(params.startDate, params.endDate, holiday.startDate, holiday.endDate)) {
          return const Left(ValidationFailure('يوجد تداخل مع عطلة رسمية.'));
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