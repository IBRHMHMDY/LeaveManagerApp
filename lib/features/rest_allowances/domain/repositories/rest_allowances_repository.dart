// lib/features/rest_allowances/domain/repositories/rest_allowances_repository.dart
import 'package:dartz/dartz.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';

abstract class RestAllowancesRepository {
  /// إضافة عمل إضافي أو عطلة جديدة (غير مستخدمة)
  Future<Either<Failure, Unit>> addExtraWork(ExtraWorkRecord record);
  
  /// جلب جميع السجلات المتاحة والمستهلكة
  Future<Either<Failure, List<ExtraWorkRecord>>> getAllExtraWork();
  
  /// استخدام رصيد متاح وتحويله لبدل راحة (يدعم تقسيم السجلات برمجياً)
  Future<Either<Failure, Unit>> useRestAllowance({
    required int id,
    required int usedDaysCount,
    required DateTime restStartDate,
    required DateTime restEndDate,
    String? notes,
  });
  
  /// حذف سجل
  Future<Either<Failure, Unit>> deleteExtraWork(int id);
}