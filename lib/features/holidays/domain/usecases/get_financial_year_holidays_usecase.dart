// lib/features/holidays/domain/usecases/get_financial_year_holidays_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/domain/repositories/holidays_repository.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';

@lazySingleton
class GetFinancialYearHolidaysUseCase implements BaseUseCase<List<Holiday>, NoParams> {
  final HolidaysRepository repository;
  final GetSettingsUseCase getSettings; // <-- تم الحقن

  GetFinancialYearHolidaysUseCase(this.repository, this.getSettings);

  @override
  Future<Either<Failure, List<Holiday>>> call(NoParams params) async {
    final settingsResult = await getSettings(const NoParams());
    
    return settingsResult.fold(
      (failure) => Left(failure),
      (settings) async {
        final start = FinancialYearCalculator.getYearStart(settings.financialYearType);
        final end = FinancialYearCalculator.getYearEnd(settings.financialYearType);
        
        return await repository.getFinancialYearHolidays(start, end);
      },
    );
  }
}