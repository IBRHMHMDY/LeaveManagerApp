// lib/features/home/presentation/cubit/home_cubit.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_extra_work_records_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetSettingsUseCase getSettings;
  final CalculateBalancesUseCase calculateBalances;
  final GetCurrentYearLeavesUseCase getCurrentYearLeaves;
  final GetExtraWorkRecordsUseCase getExtraWorkRecords;

  HomeCubit({
    required this.getSettings,
    required this.calculateBalances,
    required this.getCurrentYearLeaves,
    required this.getExtraWorkRecords,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    final results = await Future.wait([
      getSettings(const NoParams()),
      calculateBalances(const NoParams()),
      getCurrentYearLeaves(const NoParams()),
      getExtraWorkRecords(const NoParams()),
    ]);

    final settingsResult = results[0] as Either<Failure, Settings>;
    final balanceResult = results[1] as Either<Failure, LeaveBalance>;
    final leavesResult = results[2] as Either<Failure, List<LeaveRecord>>;
    final extraWorkResult = results[3] as Either<Failure, List<ExtraWorkRecord>>;

    Settings? settings;
    LeaveBalance? balance;
    String? criticalError;

    settingsResult.fold(
      (failure) => criticalError = failure.message,
      (data) => settings = data,
    );
    balanceResult.fold(
      (failure) => criticalError ??= failure.message, // الاحتفاظ بأول خطأ حرج
      (data) => balance = data,
    );
    if (criticalError != null || settings == null || balance == null) {
      emit(HomeError(criticalError ?? 'حدث خطأ غير متوقع أثناء جلب البيانات الأساسية.'));
      return;
    }
    List<LeaveRecord> currentMonthLeaves = [];
    leavesResult.fold(
      (failure) {},
      (leaves) {
        final now = DateTime.now();
        currentMonthLeaves = leaves.where((leave) =>
            leave.startDate.month == now.month &&
            leave.startDate.year == now.year).toList();
      },
    );
    List<ExtraWorkRecord> currentMonthRestAllowances = [];
    extraWorkResult.fold(
      (failure) {
        // تسجيل الخطأ بصمت
      },
      (extraWorks) {
        final now = DateTime.now();
        currentMonthRestAllowances = extraWorks.where((record) {
          final isWorkInMonth = !record.isUsed &&
              record.workStartDate.month == now.month &&
              record.workStartDate.year == now.year;

          final isRestInMonth = record.isUsed &&
              record.restStartDate != null &&
              record.restStartDate!.month == now.month &&
              record.restStartDate!.year == now.year;

          return isWorkInMonth || isRestInMonth;
        }).toList();
      },
    );
    
    emit(HomeLoaded(
      settings: settings!,
      balance: balance!,
      currentMonthLeaves: currentMonthLeaves,
      currentMonthRestAllowances: currentMonthRestAllowances,
    ));
  }
}