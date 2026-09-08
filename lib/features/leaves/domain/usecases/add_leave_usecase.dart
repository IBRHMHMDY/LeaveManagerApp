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
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';

@lazySingleton
class AddLeaveUseCase implements BaseUseCase<Unit, LeaveRecord> {
  final LeaveRepository repository;
  final CalculateBalancesUseCase calculateBalances;
  final CheckDateOverlapUseCase checkDateOverlap; // حقن حالة الاستخدام الجديدة
  final GetSettingsUseCase getSettings;

  AddLeaveUseCase({
    required this.repository,
    required this.calculateBalances,
    required this.checkDateOverlap,
    required this.getSettings,
  });

  @override
  Future<Either<Failure, Unit>> call(LeaveRecord leave) async {
    // 1. التحقق من الرصيد (Functional)
    final balanceResult = await calculateBalances(const NoParams());

    return balanceResult.fold((failure) async => Left(failure), (
      balance,
    ) async {
      // --- تطبيق قواعد الأعمال (Business Rules) ---
      if ((balance.remainingRegular +
              balance.remainingCasual +
              balance.remainingSick) ==
          0) {
        return const Left(
          ValidationFailure('لا يوجد رصيد كافٍ لإضافة أي إجازة.'),
        );
      }

      if (leave.leaveType == LeaveType.regular &&
          balance.remainingRegular < leave.daysCount) {
        return Left(
          ValidationFailure(
            'رصيد الإجازات الاعتيادية لا يكفي (المتبقي: ${balance.remainingRegular} أيام، المطلوب: ${leave.daysCount} أيام).',
          ),
        );
      }

      if (leave.leaveType == LeaveType.casual &&
          balance.remainingCasual < leave.daysCount) {
        return Left(
          ValidationFailure(
            'رصيد الإجازات العارضة لا يكفي (المتبقي: ${balance.remainingCasual} أيام، المطلوب: ${leave.daysCount} أيام).',
          ),
        );
      }

      // ✅ إضافة قاعدة التحقق الخاصة بالإجازة المرضية
      if (leave.leaveType == LeaveType.sick &&
          balance.remainingSick < leave.daysCount) {
        return Left(
          ValidationFailure(
            'رصيد الإجازات المرضية لا يكفي (المتبقي: ${balance.remainingSick} أيام، المطلوب: ${leave.daysCount} أيام).',
          ),
        );
      }

      // 2. التحقق من وقوع الإجازة داخل السنة المالية
      // 1. جلب الإعدادات
      final settingsResult = await getSettings(const NoParams());
      if (settingsResult.isLeft()) {
        return Left(settingsResult.fold((l) => l, (r) => throw Exception()));
      }
      final settings = settingsResult.getOrElse(() => throw Exception());

      // 2. التحقق من وقوع التاريخ داخل السنة المالية/الميلادية
      if (!FinancialYearCalculator.isDateInYear(
            leave.startDate,
            settings.financialYearType,
          ) ||
          !FinancialYearCalculator.isDateInYear(
            leave.endDate,
            settings.financialYearType,
          )) {
        return const Left(
          ValidationFailure(
            'تاريخ الإجازة يقع خارج نطاق السنة المالية الحالية.',
          ),
        );
      }

      // 3. التحقق من عدم التداخل مع إجازات أخرى
      final overlapCheck = await checkDateOverlap(
        DateRangeParams(
          startDate: leave.startDate,
          endDate: leave.endDate,
          allowHolidayOverlap: true,
        ),
      );

      return overlapCheck.fold((failure) async => Left(failure), (_) async {
        // 4. الحفظ في قاعدة البيانات
        return await repository.addLeave(leave);
      });
    });
  }
}
