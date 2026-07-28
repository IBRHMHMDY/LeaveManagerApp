// lib/features/rest_allowances/domain/usecases/consume_rest_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/usecases/check_date_overlap_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

class AddRestParams {
  final RestAllowance allowance;
  final DateTime linkedOvertimeStartDate;

  AddRestParams({required this.allowance, required this.linkedOvertimeStartDate});
}

@lazySingleton
class AddRestUseCase implements BaseUseCase<Unit, AddRestParams> {
  final RestAllowancesRepository repository;
  final CheckDateOverlapUseCase checkDateOverlap;

  AddRestUseCase(this.repository, this.checkDateOverlap);

  @override
  Future<Either<Failure, Unit>> call(AddRestParams params) async {
    // 1. التحقق من النطاق الزمني للسنة المالية
    if (!FinancialYearCalculator.isDateInCurrentFinancialYear(params.allowance.startDate) ||
        !FinancialYearCalculator.isDateInCurrentFinancialYear(params.allowance.endDate)) {
      return const Left(ValidationFailure('التاريخ المختار خارج النطاق. يرجى التأكد من أن بدل الراحة يقع ضمن السنة المالية الحالية.'));
    }

    // 2. التحقق من التسلسل الزمني
    final restStart = DateTime(params.allowance.startDate.year, params.allowance.startDate.month, params.allowance.startDate.day);
    final overtimeStart = DateTime(params.linkedOvertimeStartDate.year, params.linkedOvertimeStartDate.month, params.linkedOvertimeStartDate.day);
    
    if (restStart.isBefore(overtimeStart)) {
      return const Left(ValidationFailure('يمنع اختيار تاريخ بدل راحة سابق على تاريخ العطلة أو العمل الإضافي.'));
    }

    // 3. التحقق من التداخل
    final overlapCheck = await checkDateOverlap(
      DateRangeParams(startDate: params.allowance.startDate, endDate: params.allowance.endDate)
    );

    return overlapCheck.fold(
      (failure) => Left(failure),
      (_) async {
        // 4. حفظ بدل الراحة
        final addResult = await repository.addRestAllowance(params.allowance);
        
        return addResult.fold(
          (failure) => Left(failure),
          (_) async {
            // 5. [إصلاح الخلل]: تحديث حالة العمل الإضافي ليصبح مستهلكاً (مما يؤدي لشطبه بصرياً وإخفائه)
            return await repository.updateOvertimeConsumedStatus(params.allowance.overtimeId, true);
          }
        );
      },
    );
  }
}