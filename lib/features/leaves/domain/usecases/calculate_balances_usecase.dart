import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../../../../core/utils/enums/leave_type.dart';
import '../entities/leave_balance_entity.dart';
import 'get_current_year_leaves_usecase.dart';
import '../../../settings/domain/usecases/get_settings_usecase.dart';
import '../../../extra_work_days/domain/usecases/get_extra_work_days_usecase.dart'; // استيراد الـ UseCase الجديد

class CalculateBalancesUseCase implements BaseUseCase<LeaveBalance, NoParams> {
  final GetSettingsUseCase getSettingsUseCase;
  final GetCurrentYearLeavesUseCase getCurrentYearLeavesUseCase;
  final GetExtraWorkDaysUseCase getExtraWorkDaysUseCase; // حقن (Injection)

  CalculateBalancesUseCase({
    required this.getSettingsUseCase,
    required this.getCurrentYearLeavesUseCase,
    required this.getExtraWorkDaysUseCase, 
  });

  @override
  Future<Either<Failure, LeaveBalance>> call(NoParams params) async {
    // 1. جلب الإعدادات (الأرصدة الأساسية)
    final settingsResult = await getSettingsUseCase(const NoParams());
    
    return settingsResult.fold(
      (failure) => Left(failure),
      (settings) async {
        // 2. جلب إجازات العام الحالي (المستهلكة)
        final leavesResult = await getCurrentYearLeavesUseCase(const NoParams());
        
        return leavesResult.fold(
          (failure) => Left(failure),
          (leaves) async {
            // 3. جلب أيام العمل الإضافية (رصيد بدلات الراحة المكتسب)
            final extraWorkResult = await getExtraWorkDaysUseCase(const NoParams());
            
            return extraWorkResult.fold(
              (failure) => Left(failure),
              (extraWorkDays) {
                
                int consumedRegular = 0;
                int consumedCasual = 0;
                int consumedRest = 0; 

                // حساب الأيام المستهلكة من كل نوع
                for (var leave in leaves) {
                  if (leave.leaveType == LeaveType.regular) {
                    consumedRegular += leave.daysCount;
                  } else if (leave.leaveType == LeaveType.casual) {
                    consumedCasual += leave.daysCount;
                  } else if (leave.leaveType == LeaveType.restAllowance) {
                    consumedRest += leave.daysCount; 
                  }
                }

                // حساب رصيد بدل الراحة: (إجمالي أيام العمل الإضافية - الإجازات المستهلكة من نوع بدل راحة)
                // نفترض هنا أن كل يوم عمل إضافي مسجل يمثل (1 يوم) بدل راحة
                int totalAcquiredRestAllowances = extraWorkDays.length;

                return Right(LeaveBalance(
                  remainingRegular: settings.totalRegularLeaves - consumedRegular,
                  remainingCasual: settings.totalCasualLeaves - consumedCasual,
                  remainingRestAllowances: totalAcquiredRestAllowances - consumedRest,
                ));
              },
            );
          },
        );
      },
    );
  }
}