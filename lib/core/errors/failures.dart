abstract class Failure {
  final String message;
  const Failure(this.message);
}

// خطأ متعلق بقاعدة البيانات المحلية (Drift)
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

// خطأ متعلق بالتحقق من صحة البيانات (مثال: تسجيل إجازة خارج السنة المالية)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}