// lib/core/utils/holidays_data_factory.dart
import '../../features/holidays/domain/entities/holiday_entity.dart';

class HolidaysDataFactory {
  /// الحصول على قائمة الإجازات الرسمية بناءً على الدولة.
  /// يتم تمرير [startYear] ليمثل بداية السنة المالية (1 يوليو) 
  /// ويتم احتساب النصف الثاني من السنة المالية في [endYear].
  static List<Holiday> getHolidaysForCountry(String country, int startYear) {
    switch (country) {
      case 'مصر':
        return _getEgyptHolidays(startYear);
      // يمكن التوسع مستقبلاً لدول أخرى في السوق
      default:
        return [];
    }
  }

  static List<Holiday> _getEgyptHolidays(int startYear) {
    // السنة التي تنتهي فيها السنة المالية
    final int endYear = startYear + 1;

    return [
      // ---------------- النصف الأول (يوليو - ديسمبر من startYear) ----------------
      Holiday(
        id: 0,
        name: 'ثورة 23 يوليو',
        startDate: DateTime(startYear, 7, 23),
        endDate: DateTime(startYear, 7, 23),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'المولد النبوي الشريف',
        startDate: DateTime(startYear, 8, 26), // * تاريخ تقريبي يعتمد على الرؤية الهجرية
        endDate: DateTime(startYear, 8, 26),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'عيد القوات المسلحة (6 أكتوبر)',
        startDate: DateTime(startYear, 10, 6),
        endDate: DateTime(startYear, 10, 6),
        country: 'مصر',
      ),

      // ---------------- النصف الثاني (يناير - يونيو من endYear) ----------------
      Holiday(
        id: 0,
        name: 'عيد الميلاد المجيد',
        startDate: DateTime(endYear, 1, 7),
        endDate: DateTime(endYear, 1, 7),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'عيد الشرطة وثورة 25 يناير',
        startDate: DateTime(endYear, 1, 25),
        endDate: DateTime(endYear, 1, 25),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'عيد الفطر المبارك',
        startDate: DateTime(endYear, 3, 9), // * تاريخ تقريبي يعتمد على الرؤية الهجرية
        endDate: DateTime(endYear, 3, 11),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'عيد تحرير سيناء',
        startDate: DateTime(endYear, 4, 25),
        endDate: DateTime(endYear, 4, 25),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'عيد العمال',
        startDate: DateTime(endYear, 5, 1),
        endDate: DateTime(endYear, 5, 1),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'شم النسيم',
        startDate: DateTime(endYear, 5, 3), // مرتبط بالتقويم القبطي وعيد الفصح
        endDate: DateTime(endYear, 5, 3),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'وقفة عرفات وعيد الأضحى المبارك',
        startDate: DateTime(endYear, 5, 15), // * تاريخ تقريبي يعتمد على الرؤية الهجرية
        endDate: DateTime(endYear, 5, 19),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'رأس السنة الهجرية',
        startDate: DateTime(endYear, 6, 5), // * تاريخ تقريبي
        endDate: DateTime(endYear, 6, 5),
        country: 'مصر',
      ),
      Holiday(
        id: 0,
        name: 'ثورة 30 يونيو',
        startDate: DateTime(endYear, 6, 30),
        endDate: DateTime(endYear, 6, 30),
        country: 'مصر',
      ),
    ];
  }
}