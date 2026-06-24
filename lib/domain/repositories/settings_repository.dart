import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/settings.dart';

abstract class SettingsRepository {
  /// التحقق من وجود إعدادات مسجلة (لتحديد مسار الشاشة الأولى)
  Future<Either<Failure, bool>> hasSettings();
  
  /// جلب الإعدادات الحالية
  Future<Either<Failure, Settings>> getSettings();
  
  /// حفظ أو تحديث الإعدادات
  Future<Either<Failure, Unit>> saveSettings(Settings settings);
}