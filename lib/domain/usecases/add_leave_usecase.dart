import 'package:dartz/dartz.dart';
import 'package:vacation_tracker/core/errors/failures.dart';
import 'package:vacation_tracker/core/usecases/base_usecase.dart';
import 'package:vacation_tracker/core/utils/financial_year_calculator.dart';
import 'package:vacation_tracker/domain/entities/leave_record.dart';
import 'package:vacation_tracker/domain/entities/leave_type.dart';
import 'package:vacation_tracker/domain/repositories/leave_repository.dart';


class AddLeaveUseCase implements BaseUseCase<Unit, LeaveRecord> {
  final LeaveRepository repository;

  AddLeaveUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(LeaveRecord leave) async {
    // 1. التحقق من أن الإجازة تقع ضمن السنة المالية الحالية
    if (!FinancialYearCalculator.isDateInCurrentFinancialYear(leave.startDate) ||
        !FinancialYearCalculator.isDateInCurrentFinancialYear(leave.endDate)) {
      return const Left(ValidationFailure('يبدو أن التاريخ المختار خارج النطاق. يرجى التأكد من أن الإجازة تقع ضمن السنة المالية الحالية.'));
    }

    // 2. جلب إجازات السنة المالية الحالية للتحقق من عدم وجود تداخل
    final startFinYear = FinancialYearCalculator.currentFinancialYearStart;
    final endFinYear = FinancialYearCalculator.currentFinancialYearEnd;
    
    final existingLeavesResult = await repository.getLeavesBetweenDates(startFinYear, endFinYear);
    
    return existingLeavesResult.fold(
      (failure) => Left(failure), // خطأ في قاعدة البيانات
      (existingLeaves) async {
        // فحص التقاطع (Overlap) مع الإجازات الموجودة مسبقاً
        for (var existingLeave in existingLeaves) {
          // تجريد التواريخ من الساعات والدقائق لضمان دقة المقارنة على مستوى الأيام فقط
          final newStart = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
          final newEnd = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);
          final oldStart = DateTime(existingLeave.startDate.year, existingLeave.startDate.month, existingLeave.startDate.day);
          final oldEnd = DateTime(existingLeave.endDate.year, existingLeave.endDate.month, existingLeave.endDate.day);

          // شرط التقاطع: (البداية الجديدة <= النهاية القديمة) و (النهاية الجديدة >= البداية القديمة)
          final isOverlapping = !newStart.isAfter(oldEnd) && !newEnd.isBefore(oldStart);

          if (isOverlapping) {
            final leaveTypeName = existingLeave.leaveType == LeaveType.regular ? 'اعتيادية' : 'عارضة';
            
            return Left(ValidationFailure('تداخل في التواريخ: لديك إجازة "$leaveTypeName" مسجلة بالفعل في نفس الفترة، يرجى مراجعة السجل.'));
          }
        }

        // 3. إذا اجتاز التحقق بنجاح، يتم الحفظ
        return await repository.addLeave(leave);
      },
    );
  }
}