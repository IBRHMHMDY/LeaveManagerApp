// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

/// الكلاس الأب لجميع الأخطاء في طبقة الـ Domain (يرجع داخل Either<Failure, T>).
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// فشل في قاعدة البيانات المحلية (Drift).
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// فشل في التحقق من صحة البيانات أو قواعد العمل.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// فشل قادم من الخادم البعيد (API).
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(super.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// فشل بسبب عدم توفر اتصال بالإنترنت.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'لا يوجد اتصال بالإنترنت حالياً.',
  ]);
}

/// فشل في قراءة أو كتابة البيانات في التخزين الآمن أو الكاش.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}