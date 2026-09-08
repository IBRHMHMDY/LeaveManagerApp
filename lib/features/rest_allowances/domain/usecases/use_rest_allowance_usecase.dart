// lib/features/rest_allowances/domain/usecases/use_rest_allowance_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/usecases/check_date_overlap_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';

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
class UseRestAllowanceUseCase
    implements BaseUseCase<Unit, UseRestAllowanceParams> {
  final RestAllowancesRepository repository;
  final CheckDateOverlapUseCase checkDateOverlap;
  final GetSettingsUseCase getSettings;

  UseRestAllowanceUseCase(
    this.repository,
    this.checkDateOverlap,
    this.getSettings,
  );

  @override
  Future<Either<Failure, Unit>> call(UseRestAllowanceParams restLeave) async {
    // 1. التحقق من السنة المالية
    final settingsResult = await getSettings(const NoParams());
    if (settingsResult.isLeft()) {
      return Left(settingsResult.fold((l) => l, (r) => throw Exception()));
    }
    final settings = settingsResult.getOrElse(() => throw Exception());

    // 2. التحقق من وقوع التاريخ داخل السنة المالية/الميلادية
    if (!FinancialYearCalculator.isDateInYear(
          restLeave.restStartDate,
          settings.financialYearType,
        ) ||
        !FinancialYearCalculator.isDateInYear(
          restLeave.restEndDate,
          settings.financialYearType,
        )) {
      return const Left(
        ValidationFailure(
          'تواريخ الراحة يجب أن تكون ضمن السنة المالية الحالية.',
        ),
      );
    }

    // 2. التحقق من التداخل (Overlap)
    final overlapCheck = await checkDateOverlap(
      DateRangeParams(
        startDate: restLeave.restStartDate,
        endDate: restLeave.restEndDate,
      ),
    );

    return overlapCheck.fold((failure) => Left(failure), (_) async {
      return await repository.useRestAllowance(
        id: restLeave.allowanceId,
        usedDaysCount: restLeave.usedDaysCount,
        restStartDate: restLeave.restStartDate,
        restEndDate: restLeave.restEndDate,
        notes: restLeave.notes,
      );
    });
  }
}
