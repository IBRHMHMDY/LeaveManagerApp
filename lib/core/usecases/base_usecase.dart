import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

// Type: نوع البيانات المرجعة في حالة النجاح
// Params: المعاملات الممررة لحالة الاستخدام
abstract class BaseUseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

// كلاس مساعد في حالة كانت حالة الاستخدام لا تتطلب أي معاملات
class NoParams {
  const NoParams();
}