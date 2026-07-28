// lib/features/leaves/domain/usecases/add_leave_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/core/usecases/check_date_overlap_usecase.dart'; // تمت إضافة الاستدعاء
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';

@lazySingleton
class AddLeaveUseCase implements BaseUseCase<Unit, LeaveRecord> {
  final LeaveRepository repository;
  final CalculateBalancesUseCase calculateBalances;
  final CheckDateOverlapUseCase checkDateOverlap; // حقن حالة الاستخدام الجديدة

  AddLeaveUseCase({
    required this.repository,
    required this.calculateBalances,
    required this.checkDateOverlap,
  });

  @override
  Future<Either<Failure, Unit>> call(LeaveRecord leave) async {
    // 1. التحقق من الرصيد (Functional)
    final balanceResult = await calculateBalances(const NoParams());
    
    return balanceResult.fold(
      (failure) async => Left(failure),
      (balance) async {
        // --- تطبيق قواعد الأعمال (Business Rules) ---
        if ((balance.remainingRegular + balance.remainingCasual) == 0) {
          return const Left(ValidationFailure('لا يوجد رصيد إجازات كافٍ.'));
        }
        
        if (leave.leaveType == LeaveType.regular && balance.remainingRegular < leave.daysCount) {
          return Left(ValidationFailure('رصيد الاعتيادي لا يكفي (المتبقي: ${balance.remainingRegular} أيام، المطلوب: ${leave.daysCount} أيام).'));
        }
        
        if (leave.leaveType == LeaveType.casual && balance.remainingCasual < leave.daysCount) {
          return Left(ValidationFailure('رصيد العارضة لا يكفي (المتبقي: ${balance.remainingCasual} أيام، المطلوب: ${leave.daysCount} أيام).'));
        }

        // 2. التحقق من السنة المالية
        if (!FinancialYearCalculator.isDateInCurrentFinancialYear(leave.startDate) ||
            !FinancialYearCalculator.isDateInCurrentFinancialYear(leave.endDate)) {
          return const Left(ValidationFailure('تاريخ الإجازة يجب أن يكون ضمن السنة المالية الحالية.'));
        }

        // 3. التحقق من التداخل الزمني الشامل باستخدام CheckDateOverlapUseCase
        final overlapCheck = await checkDateOverlap(
          DateRangeParams(startDate: leave.startDate, endDate: leave.endDate)
        );

        return overlapCheck.fold(
          (failure) async => Left(failure), // سيُرجع رسالة الخطأ إذا كان هناك تداخل
          (_) async {
             // 4. حفظ الإجازة إذا اجتازت جميع القيود
             return await repository.addLeave(leave);
          }
        );
      },
    );
  }
}