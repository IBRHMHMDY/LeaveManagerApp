import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/base_usecase.dart';
import '../repositories/extra_work_repository.dart';

class AddExtraWorkDayParams extends Equatable {
  final DateTime date;
  final String? notes;

  const AddExtraWorkDayParams({required this.date, this.notes});

  @override
  List<Object?> get props => [date, notes];
}

class AddExtraWorkDayUseCase implements BaseUseCase<Unit, AddExtraWorkDayParams> {
  final ExtraWorkRepository repository;

  AddExtraWorkDayUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AddExtraWorkDayParams params) async {
    // 1. القيد الأول: لا يمكن للموظف تسجيل يوم عمل إضافي في تاريخ مستقبلي
    final today = DateTime.now();
    if (params.date.isAfter(today)) {
      return const Left(ValidationFailure('عفواً، لا يمكن تسجيل يوم عمل إضافي في تاريخ مستقبلي.'));
    }

    // 2. جلب جميع الأيام المسجلة مسبقاً للتحقق من القيد الجديد
    final existingDaysResult = await repository.getExtraWorkDays();
    
    return existingDaysResult.fold(
      (failure) => Left(failure), // إرجاع الخطأ إذا فشل جلب البيانات
      (existingDays) async {
        
        // 3. القيد الثاني (الجديد): منع التكرار (Duplicate Check)
        // نتحقق مما إذا كان هناك يوم مسجل يطابق نفس السنة والشهر واليوم
        final isDuplicate = existingDays.any((day) => 
            day.date.year == params.date.year &&
            day.date.month == params.date.month &&
            day.date.day == params.date.day);

        if (isDuplicate) {
          // إرجاع رسالة الخطأ المطلوبة
          return const Left(ValidationFailure('التاريخ المختار مسجل بالفعل كيوم عمل إضافي . لا يمكن تسجيل نفس اليوم مرتين.'));
        }

        // 4. إذا اجتاز التاريخ جميع القيود بنجاح، يتم الحفظ
        return await repository.addExtraWorkDay(params.date, params.notes);
      },
    );
  }
}