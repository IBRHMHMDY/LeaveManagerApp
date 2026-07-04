import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';

import 'get_current_year_leaves_usecase.dart';
import '../../../settings/domain/usecases/settings_usecase.dart';

class CalculateBalancesUseCase implements BaseUseCase<LeaveBalance, NoParams> {
  final GetSettingsUseCase getSettingsUseCase;
  final GetCurrentYearLeavesUseCase getCurrentYearLeavesUseCase;

  CalculateBalancesUseCase({
    required this.getSettingsUseCase,
    required this.getCurrentYearLeavesUseCase,
  });

  @override
  Future<Either<Failure, LeaveBalance>> call(NoParams params) async {
    // 1. جلب الإعدادات (الأرصدة الإجمالية)
    final settingsResult = await getSettingsUseCase(const NoParams());
    
    return settingsResult.fold(
      (failure) => Left(failure),
      (settings) async {
        // 2. جلب إجازات السنة المالية الحالية
        final leavesResult = await getCurrentYearLeavesUseCase(const NoParams());
        
        return leavesResult.fold(
          (failure) => Left(failure),
          (leaves) {
            // 3. حساب الأيام المستهلكة ديناميكياً
            int consumedRegular = 0;
            int consumedCasual = 0;

            for (var leave in leaves) {
              if (leave.leaveType == LeaveType.regular) {
                consumedRegular += leave.daysCount;
              } else if (leave.leaveType == LeaveType.casual) {
                consumedCasual += leave.daysCount;
              }
            }

            // 4. استخراج الرصيد المتبقي
            final remainingRegular = settings.totalRegularLeaves - consumedRegular;
            final remainingCasual = settings.totalCasualLeaves - consumedCasual;

            return Right(LeaveBalance(
              remainingRegular: remainingRegular,
              remainingCasual: remainingCasual,
            ));
          },
        );
      },
    );
  }
}