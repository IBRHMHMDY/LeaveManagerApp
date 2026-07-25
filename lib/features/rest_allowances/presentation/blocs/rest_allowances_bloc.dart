import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/add_earned_rest_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/consume_rest_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/delete_rest_allowance_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_rest_allowances_usecase.dart';
import 'rest_allowances_event.dart';
import 'rest_allowances_state.dart';

@injectable
class RestAllowancesBloc
    extends Bloc<RestAllowancesEvent, RestAllowancesState> {
  final GetRestAllowancesUseCase getRestAllowances;
  final AddEarnedRestUseCase addEarnedRest;
  final ConsumeRestUseCase consumeRest;
  final DeleteRestAllowanceUseCase deleteRestAllowance;

  RestAllowancesBloc({
    required this.getRestAllowances,
    required this.addEarnedRest,
    required this.consumeRest,
    required this.deleteRestAllowance,
  }) : super(RestAllowancesInitial()) {
    on<LoadRestAllowancesEvent>(_onLoadRestAllowances);
    on<AddEarnedRestEvent>(_onAddEarnedRest);
    on<ConsumeRestEvent>(_onConsumeRest);
    on<DeleteRestEvent>(_onDeleteRest);
  }

  Future<void> _onLoadRestAllowances(
    LoadRestAllowancesEvent event,
    Emitter<RestAllowancesState> emit,
  ) async {
    emit(RestAllowancesLoading());
    final result = await getRestAllowances(const NoParams());

    result.fold((failure) => emit(RestAllowancesError(failure.message)), (
      allowances,
    ) {
      // فرز القوائم فور استلامها لتخفيف العبء عن طبقة الـ UI
      final available = allowances.where((e) => e.isAvailable).toList();
      final consumed = allowances.where((e) => !e.isAvailable).toList();

      emit(
        RestAllowancesLoaded(
          availableAllowances: available,
          consumedAllowances: consumed,
          totalAvailable: available.length,
          totalConsumed: consumed.length,
        ),
      );
    });
  }

  
  Future<void> _onAddEarnedRest(
    AddEarnedRestEvent event,
    Emitter<RestAllowancesState> emit,
  ) async {
    emit(RestAllowancesLoading());
    final result = await addEarnedRest(
      AddEarnedRestParams(earnedDate: event.earnedDate, notes: event.notes),
    );

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        // استرداد الحالة
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم تسجيل كسب الراحة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onConsumeRest(
    ConsumeRestEvent event,
    Emitter<RestAllowancesState> emit,
  ) async {
    emit(RestAllowancesLoading());
    final result = await consumeRest(
      ConsumeRestParams(id: event.id, consumedDate: event.consumedDate),
    );

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم تسجيل إجازة الراحة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onDeleteRest(
    DeleteRestEvent event,
    Emitter<RestAllowancesState> emit,
  ) async {
    emit(RestAllowancesLoading());
    final result = await deleteRestAllowance(event.id);

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        // استرداد الحالة
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم حذف السجل بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }
}
