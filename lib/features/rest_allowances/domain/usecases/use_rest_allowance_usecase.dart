// lib/features/rest_allowances/domain/usecases/use_rest_allowance_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/usecases/check_date_overlap_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

class UseRestAllowanceParams {
  final int allowanceId;
  final DateTime restStartDate;
  final DateTime restEndDate;
  final int usedDaysCount;
  final String? notes;

  UseRestAllowanceParams({
    required this.allowanceId,
    required this.restStartDate,
    required this.restEndDate,
    required this.usedDaysCount,
    this.notes,
  });
}

@lazySingleton
class UseRestAllowanceUseCase implements BaseUseCase<Unit, UseRestAllowanceParams> {
  final RestAllowancesRepository repository;
  final CheckDateOverlapUseCase checkDateOverlap;

  UseRestAllowanceUseCase(this.repository, this.checkDateOverlap);

  @override
  Future<Either<Failure, Unit>> call(UseRestAllowanceParams params) async {
    // 1. التحقق من السنة المالية
    if (!FinancialYearCalculator.isDateInCurrentFinancialYear(params.restStartDate) ||
        !FinancialYearCalculator.isDateInCurrentFinancialYear(params.restEndDate)) {
      return const Left(ValidationFailure('تواريخ الراحة يجب أن تكون ضمن السنة المالية الحالية.'));
    }

    // 2. التحقق من التداخل (Overlap)
    final overlapCheck = await checkDateOverlap(
      DateRangeParams(
        startDate: params.restStartDate,
        endDate: params.restEndDate,
      )
    );

    return overlapCheck.fold(
      (failure) => Left(failure),
      (_) async {
        return await repository.useRestAllowance(
          id: params.allowanceId,
          usedDaysCount: params.usedDaysCount,
          restStartDate: params.restStartDate,
          restEndDate: params.restEndDate,
          notes: params.notes,
        );
      },
    );
  }
}