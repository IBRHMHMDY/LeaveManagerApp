import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/domain/repositories/leave_repository.dart';

@lazySingleton
class GetCurrentYearLeavesUseCase implements BaseUseCase<List<LeaveRecord>, NoParams> {
  final LeaveRepository repository;

  GetCurrentYearLeavesUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeaveRecord>>> call(NoParams params) async {
    final start = FinancialYearCalculator.currentFinancialYearStart;
    final end = FinancialYearCalculator.currentFinancialYearEnd;
    
    return await repository.getLeavesBetweenDates(start, end);
  }
}