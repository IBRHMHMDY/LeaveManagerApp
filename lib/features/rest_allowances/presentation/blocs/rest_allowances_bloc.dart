import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/add_earned_rest_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/consume_rest_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/delete_rest_allowance_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_rest_allowances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
import 'package:leave_manager/features/holidays/domain/usecases/get_financial_year_holidays_usecase.dart';
import 'rest_allowances_event.dart';
import 'rest_allowances_state.dart';

@injectable
class RestAllowancesBloc extends Bloc<RestAllowancesEvent, RestAllowancesState> {
  final GetRestAllowancesUseCase getRestAllowances;
  final AddEarnedRestUseCase addEarnedRest;
  final ConsumeRestUseCase consumeRest;
  final DeleteRestAllowanceUseCase deleteRestAllowance;
  final GetCurrentYearLeavesUseCase getLeaves;
  final GetFinancialYearHolidaysUseCase getHolidays;

  RestAllowancesBloc({
    required this.getRestAllowances,
    required this.addEarnedRest,
    required this.consumeRest,
    required this.deleteRestAllowance,
    required this.getLeaves,
    required this.getHolidays,
  }) : super(RestAllowancesInitial()) {
    on<LoadRestAllowancesEvent>(_onLoadRestAllowances);
    on<AddEarnedRestEvent>(_onAddEarnedRest);
    on<ConsumeRestEvent>(_onConsumeRest);
    on<DeleteRestEvent>(_onDeleteRest);
  }

  Future<void> _onLoadRestAllowances(
      LoadRestAllowancesEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());
    final result = await getRestAllowances(const NoParams());
    
    result.fold(
      (failure) => emit(RestAllowancesError(failure.message)),
      (allowances) {
        final earned = allowances.where((e) => e.isEarned).toList();
        final consumed = allowances.where((e) => e.isConsumed).toList();
        
        final totalEarnedDays = earned.fold<int>(0, (sum, e) => sum + e.daysCount);
        final totalConsumedDays = consumed.fold<int>(0, (sum, e) => sum + e.daysCount);
        final totalAvailableDays = totalEarnedDays - totalConsumedDays;
        
        emit(RestAllowancesLoaded(
          earnedAllowances: earned,
          consumedAllowances: consumed,
          totalAvailableDays: totalAvailableDays,
          totalConsumedDays: totalConsumedDays,
        ));
      },
    );
  }

  Future<void> _onAddEarnedRest(
      AddEarnedRestEvent event, Emitter<RestAllowancesState> emit) async {
    
    if (!_isValidFinancialYear(event.startDate, event.endDate)) {
      emit(const RestAllowancesError('عفواً، التواريخ المحددة خارج السنة المالية الحالية.'));
      add(LoadRestAllowancesEvent());
      return;
    }

    emit(RestAllowancesLoading());
    
    // استثناء العطلات من فحص التداخل لأن العمل الإضافي يتم في العطلات
    final hasOverlap = await _isOverlapping(event.startDate, event.endDate, isEarned: true);
    if (hasOverlap) {
      emit(const RestAllowancesError('يوجد تداخل مع إجازة أو عمل إضافي مسجل مسبقاً.'));
      add(LoadRestAllowancesEvent());
      return;
    }

    final result = await addEarnedRest(AddEarnedRestParams(
      startDate: event.startDate,
      endDate: event.endDate,
      notes: event.notes,
    ));

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تمت إضافة أيام العمل الإضافي بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onConsumeRest(
      ConsumeRestEvent event, Emitter<RestAllowancesState> emit) async {
    
    if (!_isValidFinancialYear(event.startDate, event.endDate)) {
      emit(const RestAllowancesError('عفواً، التواريخ المحددة خارج السنة المالية الحالية.'));
      add(LoadRestAllowancesEvent());
      return;
    }

    // منطق حماية لضمان أن تاريخ الاستهلاك لا يسبق تاريخ اكتساب الرصيد
    final startOnly = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
    final linkedOnly = DateTime(event.linkedEarnedDate.year, event.linkedEarnedDate.month, event.linkedEarnedDate.day);
    
    if (startOnly.isBefore(linkedOnly)) {
      emit(const RestAllowancesError('لا يمكن أن يكون تاريخ استهلاك الراحة قبل تاريخ العمل الإضافي المرتبط به.'));
      add(LoadRestAllowancesEvent());
      return;
    }

    emit(RestAllowancesLoading());
    
    final restsRes = await getRestAllowances(const NoParams());
    int availableDays = 0;
    restsRes.fold(
      (l) => null,
      (allowances) {
        final earned = allowances.where((e) => e.isEarned).fold<int>(0, (sum, e) => sum + e.daysCount);
        final consumed = allowances.where((e) => e.isConsumed).fold<int>(0, (sum, e) => sum + e.daysCount);
        availableDays = earned - consumed;
      }
    );

    final daysToConsume = event.endDate.difference(event.startDate).inDays + 1;
    if (daysToConsume > availableDays) {
      emit(const RestAllowancesError('عفواً، رصيد بدلات الراحة المتاح لا يكفي.'));
      add(LoadRestAllowancesEvent());
      return;
    }

    // تفعيل الفحص الشامل (بما فيه العطلات) عند الاستهلاك
    final hasOverlap = await _isOverlapping(event.startDate, event.endDate, isEarned: false);
    if (hasOverlap) {
      emit(const RestAllowancesError('يوجد تداخل مع إجازة أو عطلة مسجلة مسبقاً.'));
      add(LoadRestAllowancesEvent());
      return;
    }

    final result = await consumeRest(ConsumeRestParams(
      startDate: event.startDate,
      endDate: event.endDate,
      notes: event.notes,
      linkedEarnedDate: event.linkedEarnedDate,
    ));

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم استهلاك بدل الراحة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onDeleteRest(
      DeleteRestEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());
    final result = await deleteRestAllowance(event.id);
    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم حذف السجل بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  bool _isValidFinancialYear(DateTime start, DateTime end) {
    return FinancialYearCalculator.isDateInCurrentFinancialYear(start) &&
           FinancialYearCalculator.isDateInCurrentFinancialYear(end);
  }

  /// فحص التداخل الزمني مع تمرير متغير يحدد نوع العملية
  Future<bool> _isOverlapping(DateTime start, DateTime end, {required bool isEarned}) async {
    final startOnly = DateTime(start.year, start.month, start.day);
    final endOnly = DateTime(end.year, end.month, end.day);
    bool hasOverlap = false;

    // 1. التحقق من الإجازات (سارٍ على الاكتساب والاستهلاك)
    final leavesRes = await getLeaves(const NoParams());
    leavesRes.fold(
      (l) => null,
      (leaves) {
        for (var l in leaves) {
          final lStart = DateTime(l.startDate.year, l.startDate.month, l.startDate.day);
          final lEnd = DateTime(l.endDate.year, l.endDate.month, l.endDate.day);
          if (!startOnly.isAfter(lEnd) && !endOnly.isBefore(lStart)) {
            hasOverlap = true;
            break;
          }
        }
      },
    );
    if (hasOverlap) return true;

    // 2. التحقق من العطلات (ممنوع الاستهلاك أيام العطلات، ولكن مسموح الاكتساب)
    if (!isEarned) {
      final holidaysRes = await getHolidays(DateRangeParams(
        start: FinancialYearCalculator.currentFinancialYearStart,
        end: FinancialYearCalculator.currentFinancialYearEnd,
      ));
      holidaysRes.fold(
        (l) => null,
        (holidays) {
          for (var h in holidays) {
            final hStart = DateTime(h.startDate.year, h.startDate.month, h.startDate.day);
            final hEnd = DateTime(h.endDate.year, h.endDate.month, h.endDate.day);
            if (!startOnly.isAfter(hEnd) && !endOnly.isBefore(hStart)) {
              hasOverlap = true;
              break;
            }
          }
        },
      );
      if (hasOverlap) return true;
    }

    // 3. التحقق من بدلات الراحة السابقة (سارٍ على الاثنين)
    final restsRes = await getRestAllowances(const NoParams());
    restsRes.fold(
      (l) => null,
      (rests) {
        for (var r in rests) {
          final rStart = DateTime(r.startDate.year, r.startDate.month, r.startDate.day);
          final rEnd = DateTime(r.endDate.year, r.endDate.month, r.endDate.day);
          if (!startOnly.isAfter(rEnd) && !endOnly.isBefore(rStart)) {
            hasOverlap = true;
            break;
          }
        }
      },
    );

    return hasOverlap;
  }
}