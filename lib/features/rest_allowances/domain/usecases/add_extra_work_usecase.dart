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
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';

@lazySingleton
class AddExtraWorkUseCase implements BaseUseCase<Unit, ExtraWorkRecord> {
  final RestAllowancesRepository repository;
  final CheckDateOverlapUseCase checkDateOverlap;
  final GetSettingsUseCase getSettings;

  AddExtraWorkUseCase(this.repository, this.checkDateOverlap, this.getSettings);

  @override
  Future<Either<Failure, Unit>> call(ExtraWorkRecord extraWork) async {
    // 1. التحقق من السنة المالية
    final settingsResult = await getSettings(const NoParams());
    if (settingsResult.isLeft()) {
      return Left(settingsResult.fold((l) => l, (r) => throw Exception()));
    }
    final settings = settingsResult.getOrElse(() => throw Exception());

    // 2. التحقق من وقوع التاريخ داخل السنة المالية/الميلادية
    if (!FinancialYearCalculator.isDateInYear(
          extraWork.workStartDate,
          settings.financialYearType,
        ) ||
        !FinancialYearCalculator.isDateInYear(
          extraWork.workEndDate,
          settings.financialYearType,
        )) {
      return const Left(
        ValidationFailure('يجب أن تكون التواريخ ضمن السنة المالية الحالية.'),
      );
    }

    // 2. منع تكرار العطلة المسجلة مسبقاً
    if (extraWork.workReason == WorkReason.holiday && extraWork.holidayId != null) {
      final recordsResult = await repository.getAllExtraWork();

      Failure? duplicateFailure;
      recordsResult.fold((failure) => duplicateFailure = failure, (records) {
        final isAlreadyRegistered = records.any(
          (r) => r.holidayId == extraWork.holidayId,
        );
        if (isAlreadyRegistered) {
          duplicateFailure = const ValidationFailure(
            'تم تسجيل بدل راحة لهذه العطلة مسبقاً.',
          );
        }
      });

      if (duplicateFailure != null) return Left(duplicateFailure!);
    }

    // 3. التحقق من التداخل
    final overlapCheck = await checkDateOverlap(
      DateRangeParams(
        startDate: extraWork.workStartDate,
        endDate: extraWork.workEndDate,
        allowHolidayOverlap: true,
      ),
    );

    return overlapCheck.fold(
      (failure) => Left(failure),
      (_) async => await repository.addExtraWork(extraWork),
    );
  }
}
