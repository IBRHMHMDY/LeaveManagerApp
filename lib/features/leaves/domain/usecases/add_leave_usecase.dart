import 'package:dartz/dartz.dart';
import 'package:vacation_tracker/core/errors/failures.dart';
import 'package:vacation_tracker/core/usecases/base_usecase.dart';
import 'package:vacation_tracker/core/utils/financial_year_calculator.dart';
import 'package:vacation_tracker/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:vacation_tracker/core/utils/enums/leave_type.dart';
import 'package:vacation_tracker/features/leaves/domain/repositories/leave_repository.dart';
import 'package:vacation_tracker/features/leaves/domain/usecases/calculate_balances_usecase.dart';

class AddLeaveUseCase implements BaseUseCase<Unit, LeaveRecord> {
  final LeaveRepository repository;
  final CalculateBalancesUseCase calculateBalances; // تم حقن حاسبة الأرصدة هنا

  AddLeaveUseCase({
    required this.repository,
    required this.calculateBalances,
  });

  @override
  Future<Either<Failure, Unit>> call(LeaveRecord leave) async {
    // 1. جلب الأرصدة الحالية والتحقق منها أولاً
    final balanceResult = await calculateBalances(const NoParams());
    
    if (balanceResult.isLeft()) {
      // إرجاع الخطأ إذا فشلنا في جلب الرصيد
      return Left(balanceResult.fold((failure) => failure, (_) => const DatabaseFailure('خطأ غير متوقع')));
    }

    final balance = balanceResult.getOrElse(() => throw Exception());

    // --- تطبيق قيود العمل (Business Rules) ---
    
    // القيد الأساسي: منع التسجيل إذا كان مجموع الأرصدة (الاعتيادي + العارضة) يساوي 0 أو أقل
    if ((balance.remainingRegular + balance.remainingCasual) == 0) {
      return const Left(ValidationFailure('عفواً، لا يمكنك تسجيل إجازة جديدة. لقد استنفدت كافة أرصدتك السنوية.'));
    }

    // قيد إضافي احترافي: التحقق من أن الرصيد الخاص بالنوع المختار يكفي لعدد الأيام المطلوبة
    if (leave.leaveType == LeaveType.regular && balance.remainingRegular < leave.daysCount) {
      return Left(ValidationFailure('رصيدك المتبقي من الإجازات الاعتيادية (${balance.remainingRegular} يوم) لا يكفي لتسجيل ${leave.daysCount} أيام.'));
    }

    if (leave.leaveType == LeaveType.casual && balance.remainingCasual < leave.daysCount) {
      return Left(ValidationFailure('رصيدك المتبقي من الإجازات العارضة (${balance.remainingCasual} يوم) لا يكفي لتسجيل ${leave.daysCount} أيام.'));
    }

    // 2. التحقق من أن الإجازة تقع ضمن السنة المالية الحالية
    if (!FinancialYearCalculator.isDateInCurrentFinancialYear(leave.startDate) ||
        !FinancialYearCalculator.isDateInCurrentFinancialYear(leave.endDate)) {
      return const Left(ValidationFailure('يبدو أن التاريخ المختار خارج النطاق. يرجى التأكد من أن الإجازة تقع ضمن السنة المالية الحالية.'));
    }

    // 3. جلب إجازات السنة المالية الحالية للتحقق من عدم وجود تداخل
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;
    
    final existingLeavesResult = await repository.getLeavesBetweenDates(startFinYear, endFinYear);
    
    return existingLeavesResult.fold(
      (failure) => Left(failure),
      (existingLeaves) async {
        // فحص التقاطع (Overlap) مع الإجازات الموجودة مسبقاً
        for (var existingLeave in existingLeaves) {
          final newStart = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
          final newEnd = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);
          final oldStart = DateTime(existingLeave.startDate.year, existingLeave.startDate.month, existingLeave.startDate.day);
          final oldEnd = DateTime(existingLeave.endDate.year, existingLeave.endDate.month, existingLeave.endDate.day);

          final isOverlapping = !newStart.isAfter(oldEnd) && !newEnd.isBefore(oldStart);

          if (isOverlapping) {
            final leaveTypeName = existingLeave.leaveType == LeaveType.regular ? 'اعتيادية' : 'عارضة';
            return Left(ValidationFailure('تداخل في التواريخ: لديك إجازة "$leaveTypeName" مسجلة بالفعل في نفس الفترة، يرجى مراجعة السجل.'));
          }
        }

        // 4. إذا اجتازت جميع التحققات، يتم الحفظ
        return await repository.addLeave(leave);
      },
    );
  }
}