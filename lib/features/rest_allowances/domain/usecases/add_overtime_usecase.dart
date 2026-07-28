// lib/features/rest_allowances/domain/usecases/add_overtime_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/usecases/check_date_overlap_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';

/// كائن يحمل البيانات المطلوبة لإضافة رصيد (سواء عمل إضافي أو عطلة)
class AddOvertimeParams {
  final DateTime startDate;
  final DateTime endDate;
  final WorkReason workReason;
  final String? notes;
  final int? holidayId;

  AddOvertimeParams({
    required this.startDate,
    required this.endDate,
    required this.workReason,
    this.notes,
    this.holidayId
  });
}

@lazySingleton
class AddOvertimeUseCase implements BaseUseCase<Unit, AddOvertimeParams> {
  final RestAllowancesRepository repository;
  final CheckDateOverlapUseCase checkDateOverlap;

  AddOvertimeUseCase(this.repository, this.checkDateOverlap);

  @override
  Future<Either<Failure, Unit>> call(AddOvertimeParams params) async {
    // 1. التحقق من السنة المالية
    if (!FinancialYearCalculator.isDateInCurrentFinancialYear(params.startDate) ||
        !FinancialYearCalculator.isDateInCurrentFinancialYear(params.endDate)) {
      return const Left(ValidationFailure('التواريخ المحددة خارج السنة المالية الحالية.'));
    }

    // 2. التحقق من عدم تسجيل العطلة مسبقاً كعمل إضافي لمنع التكرار
    if (params.workReason == WorkReason.holiday && params.holidayId != null) {
      final overtimesResult = await repository.getOvertimeRecords();
      
      Failure? duplicateFailure;
      
      // نستخدم fold لاستخراج الخطأ إن وجد بطريقة آمنة نوعياً (Type-safe)
      overtimesResult.fold(
        (failure) => duplicateFailure = failure,
        (overtimes) {
          final isAlreadyRegistered = overtimes.any((ot) => ot.holidayId == params.holidayId);
          if (isAlreadyRegistered) {
            duplicateFailure = const ValidationFailure('لقد قمت بتسجيل يوم عمل إضافي لهذه العطلة مسبقاً، لا يمكن تكرارها.');
          }
        }
      );

      // إذا تم العثور على خطأ أو تكرار، نوقف التنفيذ ونرجع الخطأ
      if (duplicateFailure != null) {
        return Left(duplicateFailure!);
      }
    }

    final overlapCheck = await checkDateOverlap(
      DateRangeParams(
        startDate: params.startDate, 
        endDate: params.endDate,
        allowHolidayOverlap: true, 
      )
    );

    return overlapCheck.fold(
      (failure) => Left(failure),
      (_) async {
        final daysCount = params.endDate.difference(params.startDate).inDays + 1;
        final record = OvertimeRecord(
          id: 0,
          workReason: params.workReason,
          startDate: params.startDate,
          endDate: params.endDate,
          daysCount: daysCount,
          isConsumed: false,
          notes: params.notes,
          holidayId: params.holidayId
        );
        return await repository.addOvertimeRecord(record);
      },
    );
  }
}