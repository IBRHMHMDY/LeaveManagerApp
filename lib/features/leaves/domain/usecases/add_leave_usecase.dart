import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/rest_allowance/extra_work_days/domain/usecases/get_extra_work_days_usecase.dart'; 

class AddLeaveUseCase implements BaseUseCase<Unit, LeaveRecord> {
  final LeaveRepository repository;
  final CalculateBalancesUseCase calculateBalances;
  final GetExtraWorkDaysUseCase getExtraWorkDays;

  AddLeaveUseCase({
    required this.repository,
    required this.calculateBalances,
    required this.getExtraWorkDays,
  });

  @override
  Future<Either<Failure, Unit>> call(LeaveRecord leave) async {
    // 1. حساب الأرصدة للتحقق
    final balanceResult = await calculateBalances(const NoParams());

    if (balanceResult.isLeft()) {
      return Left(balanceResult.fold((failure) => failure, (_) => const DatabaseFailure('حدث خطأ أثناء جلب الأرصدة')));
    }
    
    final balance = balanceResult.getOrElse(() => throw Exception());

    // التحقق من الرصيد بناءً على النوع (بما في ذلك بدل الراحة)
    if (leave.leaveType == LeaveType.regular && balance.remainingRegular < leave.daysCount) {
      return Left(ValidationFailure('رصيدك المتبقي من الإجازات الاعتيادية (${balance.remainingRegular} يوم) لا يكفي لتسجيل ${leave.daysCount} أيام.'));
    }
    if (leave.leaveType == LeaveType.casual && balance.remainingCasual < leave.daysCount) {
      return Left(ValidationFailure('رصيدك المتبقي من الإجازات العارضة (${balance.remainingCasual} يوم) لا يكفي لتسجيل ${leave.daysCount} أيام.'));
    }
    // ملاحظة: يتطلب أن يكون balance.remainingRestAllowances متاحاً حسب المرحلة السابقة
    // if (leave.leaveType == LeaveType.restAllowance && balance.remainingRestAllowances < leave.daysCount) {
    //   return Left(ValidationFailure('رصيدك المتبقي من بدلات الراحة لا يكفي.'));
    // }

    // 2. التحقق من السنة المالية
    if (!FinancialYearCalculator.isDateInCurrentFinancialYear(leave.startDate) ||
        !FinancialYearCalculator.isDateInCurrentFinancialYear(leave.endDate)) {
      return const Left(ValidationFailure('يجب أن يكون تاريخ الإجازة ضمن السنة المالية الحالية.'));
    }

    // 3. القيد الجديد: التحقق من التداخل مع أيام العمل الإضافية (إذا كانت الإجازة بدل راحة)
    if (leave.leaveType == LeaveType.restAllowance) {
      final extraWorkResult = await getExtraWorkDays(const NoParams());
      
      if (extraWorkResult.isLeft()) {
        return const Left(DatabaseFailure('حدث خطأ أثناء التحقق من أيام العمل الإضافية.'));
      }
      
      final extraWorkDays = extraWorkResult.getOrElse(() => []);
      
      DateTime currentDate = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
      final endDate = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);

      // المرور على كل يوم من أيام الإجازة المطلوبة ومطابقته
      while (!currentDate.isAfter(endDate)) {
        final isOverlap = extraWorkDays.any((ewd) => 
            ewd.date.year == currentDate.year &&
            ewd.date.month == currentDate.month &&
            ewd.date.day == currentDate.day);

        if (isOverlap) {
          return const Left(ValidationFailure('التاريخ المختار مسجل بالفعل كيوم عمل إضافي. لا يمكنك أخذ بدل راحة في يوم عملت فيه إضافياً.'));
        }
        currentDate = currentDate.add(const Duration(days: 1));
      }
    }

    // 4. التحقق من التداخل مع إجازات سابقة
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;
    final existingLeavesResult = await repository.getLeavesBetweenDates(startFinYear, endFinYear);

    return existingLeavesResult.fold(
      (failure) => Left(failure),
      (existingLeaves) async {
        for (var existingLeave in existingLeaves) {
          final newStart = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
          final newEnd = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);
          final oldStart = DateTime(existingLeave.startDate.year, existingLeave.startDate.month, existingLeave.startDate.day);
          final oldEnd = DateTime(existingLeave.endDate.year, existingLeave.endDate.month, existingLeave.endDate.day);
          
          final isOverlapping = !newStart.isAfter(oldEnd) && !newEnd.isBefore(oldStart);

          if (isOverlapping) {
            final leaveTypeName = existingLeave.leaveType == LeaveType.regular ? 'اعتيادية' : 
                                  existingLeave.leaveType == LeaveType.casual ? 'عارضة' : 'بدل راحة';
            return Left(ValidationFailure('هناك إجازة "$leaveTypeName" مسجلة مسبقاً في نفس الفترة.'));
          }
        }
        
        // 5. حفظ الإجازة في قاعدة البيانات
        return await repository.addLeave(leave);
      },
    );
  }
}