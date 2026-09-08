// lib/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';

@lazySingleton
class GetCurrentYearLeavesUseCase implements BaseUseCase<List<LeaveRecord>, NoParams> {
  final LeaveRepository repository;
  final GetSettingsUseCase getSettings; // <-- تم الحقن

  GetCurrentYearLeavesUseCase(this.repository, this.getSettings);

  @override
  Future<Either<Failure, List<LeaveRecord>>> call(NoParams params) async {
    // 1. جلب الإعدادات لمعرفة نوع السنة المالية
    final settingsResult = await getSettings(const NoParams());
    
    return settingsResult.fold(
      (failure) => Left(failure),
      (settings) async {
        // 2. حساب البداية والنهاية بناءً على الإعدادات
        final start = FinancialYearCalculator.getYearStart(settings.financialYearType);
        final end = FinancialYearCalculator.getYearEnd(settings.financialYearType);
        
        // 3. جلب الإجازات
        return await repository.getLeavesBetweenDates(start, end);
      },
    );
  }
}