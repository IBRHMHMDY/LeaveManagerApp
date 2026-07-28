// lib/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/add_overtime_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/add_rest_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/repositories/rest_allowances_repository.dart';

import 'rest_allowances_event.dart';
import 'rest_allowances_state.dart';

@injectable
class RestAllowancesBloc extends Bloc<RestAllowancesEvent, RestAllowancesState> {
  final AddOvertimeUseCase addOvertime;
  final AddRestUseCase addRest;

  final RestAllowancesRepository repository;

  RestAllowancesBloc({
    required this.addOvertime,
    required this.addRest,
    required this.repository,
  }) : super(RestAllowancesInitial()) {
    on<LoadRestAllowancesEvent>(_onLoadRestAllowances);
    on<AddEarnedRestEvent>(_onAddOverTime);
    on<ConsumeRestEvent>(_onConsumeRest);
    on<DeleteOvertimeEvent>(_onDeleteOvertime);
    on<DeleteRestEvent>(_onDeleteRestAllowance);
  }

  Future<void> _onLoadRestAllowances(
      LoadRestAllowancesEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());

    // جلب بيانات العمل الإضافي وبدلات الراحة بالتوازي
    final results = await Future.wait([
      repository.getOvertimeRecords(),
      repository.getRestAllowances(),
    ]);

    // تحديد النوع الصريح لكل نتيجة بدلاً من استخدام dynamic
    final overtimesResult = results[0] as Either<Failure, List<OvertimeRecord>>;
    final restsResult = results[1] as Either<Failure, List<RestAllowance>>;

    overtimesResult.fold(
      (failure) => emit(RestAllowancesError(failure.message)),
      (overtimes) {
        restsResult.fold(
          (failure) => emit(RestAllowancesError(failure.message)),
          (rests) {
            // الآن يتعرف Dart على overtimes و rests كقوائم صحيحة
            final totalEarnedDays = overtimes.fold<int>(0, (sum, e) => sum + e.daysCount);
            final totalConsumedDays = rests.fold<int>(0, (sum, e) => sum + e.daysCount);
            final totalAvailableDays = totalEarnedDays - totalConsumedDays;

            emit(RestAllowancesLoaded(
              earnedAllowances: overtimes,
              consumedAllowances: rests,
              totalAvailableDays: totalAvailableDays < 0 ? 0 : totalAvailableDays,
              totalConsumedDays: totalConsumedDays,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddOverTime(
      AddEarnedRestEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());

    final result = await addOvertime(AddOvertimeParams(
      startDate: event.startDate,
      endDate: event.endDate,
      workReason: event.workReason,
      notes: event.notes,
      holidayId: event.holidayId
    ));

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم تسجيل العمل الإضافي/العطلة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onConsumeRest(
      ConsumeRestEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());

    final allowance = RestAllowance(
      id: 0,
      workReason: event.workReason,
      overtimeId: event.overtimeId,
      startDate: event.startDate,
      endDate: event.endDate,
      daysCount: event.endDate.difference(event.startDate).inDays + 1,
      notes: event.notes,
    );

    final result = await addRest(AddRestParams(
      allowance: allowance,
      linkedOvertimeStartDate: event.linkedOvertimeStartDate,
    ));

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم تسجيل بدل الراحة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onDeleteOvertime(
      DeleteOvertimeEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());
    final result = await repository.deleteOvertimeRecord(event.id);
    result.fold(
      (failure) => emit(RestAllowancesError(failure.message)),
      (_) {
        emit(const RestAllowanceActionSuccess('تم حذف السجل بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onDeleteRestAllowance(
      DeleteRestEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());
    final result = await repository.deleteRestAllowance(event.id);
    result.fold(
      (failure) => emit(RestAllowancesError(failure.message)),
      (_) {
        emit(const RestAllowanceActionSuccess('تم حذف بدل الراحة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }
}