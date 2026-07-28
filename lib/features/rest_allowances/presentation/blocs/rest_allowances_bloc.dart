// lib/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/overtime_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/add_overtime_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/add_rest_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_overtime_records_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_rest_allowances_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/delete_overtime_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/delete_rest_allowance_usecase.dart';
import 'rest_allowances_event.dart';
import 'rest_allowances_state.dart';

@injectable
class RestAllowancesBloc extends Bloc<RestAllowancesEvent, RestAllowancesState> {
  // 1. حقن الـ UseCases بدلاً من الـ Repository
  final AddOvertimeUseCase addOvertime;
  final AddRestUseCase addRest;
  final GetOvertimeRecordsUseCase getOvertimeRecords;
  final GetRestAllowancesUseCase getRestAllowances;
  final DeleteOvertimeUseCase deleteOvertime;
  final DeleteRestAllowanceUseCase deleteRestAllowance;

  RestAllowancesBloc({
    required this.addOvertime,
    required this.addRest,
    required this.getOvertimeRecords,
    required this.getRestAllowances,
    required this.deleteOvertime,
    required this.deleteRestAllowance,
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

    // 2. استخدام Future.wait لجلب البيانات بشكل متوازٍ لتحسين الأداء
    final results = await Future.wait([
      getOvertimeRecords(const NoParams()),
      getRestAllowances(const NoParams()),
    ]);

    final overtimesResult = results[0] as Either<Failure, List<OvertimeRecord>>;
    final restsResult = results[1] as Either<Failure, List<RestAllowance>>;

    overtimesResult.fold(
      (failure) => emit(RestAllowancesError(failure.message)),
      (overtimes) {
        restsResult.fold(
          (failure) => emit(RestAllowancesError(failure.message)),
          (rests) {
            // حساب الأرصدة
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
      holidayId: event.holidayId,
    ));

    result.fold(
      (failure) {
        emit(RestAllowancesError(failure.message));
        add(LoadRestAllowancesEvent());
      },
      (_) {
        emit(const RestAllowanceActionSuccess('تم إضافة رصيد الراحة بنجاح.'));
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
        emit(const RestAllowanceActionSuccess('تم استهلاك الراحة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }

  Future<void> _onDeleteOvertime(
      DeleteOvertimeEvent event, Emitter<RestAllowancesState> emit) async {
    emit(RestAllowancesLoading());
    // 3. التخاطب مع UseCase حصرياً وليس Repository
    final result = await deleteOvertime(event.id);

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
    // 3. التخاطب مع UseCase حصرياً
    final result = await deleteRestAllowance(event.id);

    result.fold(
      (failure) => emit(RestAllowancesError(failure.message)),
      (_) {
        emit(const RestAllowanceActionSuccess('تم حذف الراحة المستهلكة بنجاح.'));
        add(LoadRestAllowancesEvent());
      },
    );
  }
}