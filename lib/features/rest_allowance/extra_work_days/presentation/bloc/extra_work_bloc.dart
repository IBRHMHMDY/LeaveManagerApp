import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/base_usecase.dart';
import '../../domain/usecases/add_extra_work_day_usecase.dart';
import '../../domain/usecases/delete_extra_work_day_usecase.dart';
import '../../domain/usecases/get_extra_work_days_usecase.dart';
import 'extra_work_events.dart';
import 'extra_work_state.dart';

class ExtraWorkBloc extends Bloc<ExtraWorkEvent, ExtraWorkState> {
  final GetExtraWorkDaysUseCase getExtraWorkDays;
  final AddExtraWorkDayUseCase addExtraWorkDay;
  final DeleteExtraWorkDayUseCase deleteExtraWorkDay;

  ExtraWorkBloc({
    required this.getExtraWorkDays,
    required this.addExtraWorkDay,
    required this.deleteExtraWorkDay,
  }) : super(ExtraWorkInitial()) {
    on<GetExtraWorkDaysEvent>(_onGetExtraWorkDays);
    on<AddExtraWorkDayEvent>(_onAddExtraWorkDay);
    on<DeleteExtraWorkDayEvent>(_onDeleteExtraWorkDay);
  }

  Future<void> _onGetExtraWorkDays(GetExtraWorkDaysEvent event, Emitter<ExtraWorkState> emit) async {
    emit(ExtraWorkLoading());
    final result = await getExtraWorkDays(const NoParams());
    result.fold(
      (failure) => emit(ExtraWorkError(failure.message)),
      (days) => emit(ExtraWorkLoaded(days)),
    );
  }

  Future<void> _onAddExtraWorkDay(AddExtraWorkDayEvent event, Emitter<ExtraWorkState> emit) async {
    emit(ExtraWorkLoading());
    final result = await addExtraWorkDay(AddExtraWorkDayParams(date: event.date, notes: event.notes));
    
    result.fold(
      (failure) => emit(ExtraWorkError(failure.message)),
      (_) => add(GetExtraWorkDaysEvent()), // بعد الإضافة الناجحة، نقوم بجلب البيانات من جديد
    );
  }

  Future<void> _onDeleteExtraWorkDay(DeleteExtraWorkDayEvent event, Emitter<ExtraWorkState> emit) async {
    emit(ExtraWorkLoading());
    final result = await deleteExtraWorkDay(DeleteExtraWorkDayParams(id: event.id));
    
    result.fold(
      (failure) => emit(ExtraWorkError(failure.message)),
      (_) => add(GetExtraWorkDaysEvent()), // بعد الحذف الناجح، نقوم بجلب البيانات من جديد
    );
  }
}