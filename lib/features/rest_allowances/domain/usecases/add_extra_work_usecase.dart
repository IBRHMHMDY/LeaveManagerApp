// lib/features/rest_allowances/domain/usecases/add_extra_work_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/usecases/check_date_overlap_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

@lazySingleton
class AddExtraWorkUseCase implements BaseUseCase<Unit, ExtraWorkRecord> {
  final RestAllowancesRepository repository;
  final CheckDateOverlapUseCase checkDateOverlap;

  AddExtraWorkUseCase(this.repository, this.checkDateOverlap);

  @override
  Future<Either<Failure, Unit>> call(ExtraWorkRecord params) async {
    // 1. التحقق من السنة المالية
    if (!FinancialYearCalculator.isDateInCurrentFinancialYear(params.workStartDate) ||
        !FinancialYearCalculator.isDateInCurrentFinancialYear(params.workEndDate)) {
      return const Left(ValidationFailure('يجب أن تكون التواريخ ضمن السنة المالية الحالية.'));
    }

    // 2. منع تكرار العطلة المسجلة مسبقاً
    if (params.workReason == WorkReason.holiday && params.holidayId != null) {
      final recordsResult = await repository.getAllExtraWork();
      
      Failure? duplicateFailure;
      recordsResult.fold(
        (failure) => duplicateFailure = failure,
        (records) {
          final isAlreadyRegistered = records.any((r) => r.holidayId == params.holidayId);
          if (isAlreadyRegistered) {
            duplicateFailure = const ValidationFailure('تم تسجيل بدل راحة لهذه العطلة مسبقاً.');
          }
        }
      );
      
      if (duplicateFailure != null) return Left(duplicateFailure!);
    }

    // 3. التحقق من التداخل
    final overlapCheck = await checkDateOverlap(
      DateRangeParams(
        startDate: params.workStartDate,
        endDate: params.workEndDate,
        allowHolidayOverlap: true,
      )
    );

    return overlapCheck.fold(
      (failure) => Left(failure),
      (_) async => await repository.addExtraWork(params),
    );
  }
}