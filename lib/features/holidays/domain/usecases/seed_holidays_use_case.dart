import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/holidays_data_factory.dart';
import '../repositories/holiday_repository.dart';

class SeedHolidaysUseCase {
  final HolidayRepository repository;

  const SeedHolidaysUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int year) async {
    // 1. مسح الإجازات الحالية لهذا البلد لتجنب التكرار
    final clearResult = await repository.clearHolidays();
    if (clearResult.isLeft()) return clearResult;

    // 2. جلب قائمة الإجازات من المصنع
    final holidaysToSeed = HolidaysDataFactory.getHolidays(year);

    // 3. إدخال الإجازات الجديدة في قاعدة البيانات
    for (var holiday in holidaysToSeed) {
      final addResult = await repository.addHoliday(holiday);
      if (addResult.isLeft()) {
        return addResult; // التوقف إذا حدث خطأ
      }
    }
    
    return const Right(unit);
  }
}