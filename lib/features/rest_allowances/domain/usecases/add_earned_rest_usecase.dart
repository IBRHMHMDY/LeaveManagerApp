import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

class AddEarnedRestParams {
  final DateTime earnedDate;
  final String? notes;
  AddEarnedRestParams({required this.earnedDate, this.notes});
}

@lazySingleton
class AddEarnedRestUseCase implements BaseUseCase<Unit, AddEarnedRestParams> {
  final RestAllowancesRepository repository;

  AddEarnedRestUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddEarnedRestParams params) async {
    // يمكن هنا إضافة منطق للتحقق مما إذا كان يوم الـ earnedDate يقع في عطلة أم لا 
    // إذا أردت فرض قواعد أعمال (Business Rules) إضافية.
    return await repository.addEarnedRest(params.earnedDate, params.notes);
  }
}