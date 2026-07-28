// lib/features/home/presentation/cubit/home_cubit.dart
import 'package:dartz/dartz.dart'; // 👈 ضروري لعمل Either
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_rest_allowances_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';

// 👈 استيراد الكيانات لتحديد الأنواع بصرامة
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetSettingsUseCase getSettings;
  final CalculateBalancesUseCase calculateBalances;
  final GetCurrentYearLeavesUseCase getCurrentYearLeaves;
  final GetRestAllowancesUseCase getRestAllowances;

  HomeCubit({
    required this.getSettings,
    required this.calculateBalances,
    required this.getCurrentYearLeaves,
    required this.getRestAllowances,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    
    final results = await Future.wait([
      getSettings(const NoParams()),
      calculateBalances(const NoParams()),
      getCurrentYearLeaves(const NoParams()),
      getRestAllowances(const NoParams()), 
    ]);

    // 👈 تحديد الأنواع صراحة بدلاً من dynamic
    final settingsResult = results[0] as Either<Failure, Settings>;
    final balanceResult = results[1] as Either<Failure, LeaveBalance>;
    final leavesResult = results[2] as Either<Failure, List<LeaveRecord>>;
    final restAllowancesResult = results[3] as Either<Failure, List<RestAllowance>>;

    settingsResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (settings) {
        balanceResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (balance) {
            leavesResult.fold(
              (failure) => emit(HomeError(failure.message)),
              (leaves) {
                restAllowancesResult.fold(
                  (failure) => emit(HomeError(failure.message)),
                  (allowances) {
                    final now = DateTime.now();
                    final currentMonth = now.month;
                    final currentYear = now.year;

                    final monthLeaves = leaves.where((leave) =>
                        leave.startDate.month == currentMonth &&
                        leave.startDate.year == currentYear).toList();
                    
                    final monthRestAllowances = allowances.where((allowance) {
                      return allowance.startDate.month == currentMonth &&
                             allowance.startDate.year == currentYear;
                    }).toList();

                    emit(HomeLoaded(
                      settings: settings,
                      balance: balance,
                      currentMonthLeaves: monthLeaves,
                      currentMonthRestAllowances: monthRestAllowances,
                    ));
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}