import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

class AddEarnedRestParams {
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;

  AddEarnedRestParams({
    required this.startDate,
    required this.endDate,
    this.notes,
  });
}

@lazySingleton
class AddEarnedRestUseCase implements BaseUseCase<Unit, AddEarnedRestParams> {
  final RestAllowancesRepository repository;

  AddEarnedRestUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddEarnedRestParams params) async {
    // حساب عدد الأيام بين التاريخين
    final daysCount = params.endDate.difference(params.startDate).inDays + 1;

    final allowance = RestAllowance(
      id: 0,
      type: 0, // 0 = عمل إضافي / راحة مكتسبة
      startDate: params.startDate,
      endDate: params.endDate,
      daysCount: daysCount,
      notes: params.notes,
    );

    return await repository.addRestAllowance(allowance);
  }
}
