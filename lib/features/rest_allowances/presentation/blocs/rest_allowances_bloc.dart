// lib/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/add_extra_work_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/delete_extra_work_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_extra_work_records_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/use_rest_allowance_usecase.dart';

import 'rest_allowances_event.dart';
import 'rest_allowances_state.dart';

@injectable
class RestAllowancesBloc extends Bloc<RestAllowancesEvent, RestAllowancesState> {
  final GetExtraWorkRecordsUseCase getExtraWorkRecords;
  final AddExtraWorkUseCase addExtraWork;
  final UseRestAllowanceUseCase useRestAllowance;
  final DeleteExtraWorkUseCase deleteExtraWork;

  RestAllowancesBloc({
    required this.getExtraWorkRecords,
    required this.addExtraWork,
    required this.useRestAllowance,
    required this.deleteExtraWork,
  }) : super(RestAllowancesInitial()) {
    on<LoadRestAllowancesEvent>(_onLoadRestAllowances);
    on<AddExtraWorkEvent>(_onAddExtraWork);
    on<ConsumeRestEvent>(_onConsumeRest);
    on<DeleteExtraWorkEvent>(_onDeleteExtraWork);
  }

  Future<void> _onLoadRestAllowances(
      LoadRestAllowancesEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());

    // استدعاء واحد فقط لجلب كل السجلات
    final result = await getExtraWorkRecords(const NoParams());

    result.fold(
      (failure) => emit(RestAllowancesError(failure.message)),
      (records) {
        // الفلترة في الذاكرة (In-Memory Filtering) لتقليل الضغط على قاعدة البيانات
        final extraworkList = records.where((r) => !r.isUsed).toList(); // غير مستخدم
        final restList = records.where((r) => r.isUsed).toList();       // مستخدم

        // حساب الأرصدة
        final availablesTotal = extraworkList.fold<int>(0, (sum, r) => sum + r.daysCount);
        final usageTotal = restList.fold<int>(0, (sum, r) => sum + r.daysCount);

        emit(RestAllowancesLoaded(
          extrawork: extraworkList,
          rest: restList,
          availables: availablesTotal,
          usage: usageTotal,
        ));
      },
    );
  }

  Future<void> _onAddExtraWork(
      AddExtraWorkEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());

    final record = ExtraWorkRecord(
      id: 0,
      workReason: event.workReason,
      workStartDate: event.workStartDate,
      workEndDate: event.workEndDate,
      daysCount: event.daysCount,
      isUsed: false, // متاح كافتراضي
      holidayId: event.holidayId,
      notes: event.notes,
    );

    final result = await addExtraWork(record);

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم تسجيل أيام العمل بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onConsumeRest(
      ConsumeRestEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());

    final result = await useRestAllowance(UseRestAllowanceParams(
      allowanceId: event.allowanceId,
      restStartDate: event.restStartDate,
      restEndDate: event.restEndDate,
      usedDaysCount: event.usedDaysCount,
      notes: event.notes,
    ));

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم خصم بدل الراحة وتحديث الرصيد بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onDeleteExtraWork(
      DeleteExtraWorkEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());

    final result = await deleteExtraWork(event.id);

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم الحذف بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }
}