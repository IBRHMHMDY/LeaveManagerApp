import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

class ConsumeRestParams {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime linkedEarnedDate; // مطلوب عند الاستهلاك
  final String? notes;
  
  ConsumeRestParams({
    required this.startDate, 
    required this.endDate, 
    required this.linkedEarnedDate, 
    this.notes,
  });
}

@lazySingleton
class ConsumeRestUseCase implements BaseUseCase<Unit, ConsumeRestParams> {
  final RestAllowancesRepository repository;
  
  ConsumeRestUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ConsumeRestParams params) async {
    final daysCount = params.endDate.difference(params.startDate).inDays + 1;

    final allowance = RestAllowance(
      id: 0,
      type: 1, 
      startDate: params.startDate,
      endDate: params.endDate,
      daysCount: daysCount,
      notes: params.notes,
      linkedEarnedDate: params.linkedEarnedDate, // الربط
    );

    return await repository.addRestAllowance(allowance);
  }
}