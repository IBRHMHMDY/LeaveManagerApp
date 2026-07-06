import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/financial_year_calculator.dart';
import '../../domain/usecases/add_holiday_use_case.dart';
import '../../domain/usecases/delete_holiday_use_case.dart';
import '../../domain/usecases/get_holidays_use_case.dart';
import 'holidays_event.dart';
import 'holidays_state.dart';

class HolidaysBloc extends Bloc<HolidaysEvent, HolidaysState> {
  final GetHolidaysUseCase getHolidays;
  final AddHolidayUseCase addHoliday;
  final DeleteHolidayUseCase deleteHoliday;
  
  // الاحتفاظ بالبلد المختار حالياً لتسهيل عمليات التحديث والحذف
  String _currentCountry = 'مصر';

  HolidaysBloc({
    required this.getHolidays,
    required this.addHoliday,
    required this.deleteHoliday,
  }) : super(HolidaysInitial()) {
    on<LoadHolidaysEvent>(_onLoadHolidays);
    on<AddHolidayEvent>(_onAddHoliday);
    on<DeleteHolidayEvent>(_onDeleteHoliday);
  }

  Future<void> _onLoadHolidays(LoadHolidaysEvent event, Emitter<HolidaysState> emit) async {
    emit(HolidaysLoading());
    
    // تحديث البلد الحالي إذا تم تمريره في الحدث
    _currentCountry = event.country;

    final start = FinancialYearCalculator.currentFinancialYearStart;
    final end = FinancialYearCalculator.currentFinancialYearEnd;
    
    final result = await getHolidays(start, end, _currentCountry);
    
    result.fold(
      (failure) => emit(HolidaysError(failure.message)),
      (holidays) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final upcomingHolidays = holidays.where((h) {
          final hEnd = DateTime(h.endDate.year, h.endDate.month, h.endDate.day);
          return hEnd.isAfter(today) || hEnd.isAtSameMomentAs(today);
        }).toList();

        upcomingHolidays.sort((a, b) => a.startDate.compareTo(b.startDate));
        final upcoming = upcomingHolidays.isNotEmpty ? upcomingHolidays.first : null;

        emit(HolidaysLoaded(holidays: holidays, upcomingHoliday: upcoming));
      },
    );
  }

  Future<void> _onAddHoliday(AddHolidayEvent event, Emitter<HolidaysState> emit) async {
    emit(HolidaysLoading());
    final result = await addHoliday(event.holiday);
    result.fold(
      (failure) {
        emit(HolidaysError(failure.message));
        add(LoadHolidaysEvent(_currentCountry));
      },
      (_) {
        emit(const HolidayOperationSuccess('تم إضافة الإجازة الرسمية بنجاح.'));
        add(LoadHolidaysEvent(_currentCountry));
      },
    );
  }

  Future<void> _onDeleteHoliday(DeleteHolidayEvent event, Emitter<HolidaysState> emit) async {
    emit(HolidaysLoading());
    final result = await deleteHoliday(event.id);
    result.fold(
      (failure) {
        emit(HolidaysError(failure.message));
        add(LoadHolidaysEvent(_currentCountry));
      },
      (_) {
        emit(const HolidayOperationSuccess('تم حذف الإجازة الرسمية بنجاح.'));
        add(LoadHolidaysEvent(_currentCountry));
      },
    );
  }
}