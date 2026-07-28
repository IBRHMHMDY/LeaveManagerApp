// lib/features/home/presentation/cubit/home_cubit.dart
import 'package:dartz/dartz.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
// 👈 استيراد الـ UseCase الجديد
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
  final GetExtraWorkRecordsUseCase getExtraWorkRecords; // 👈 التحديث هنا

  HomeCubit({
    required this.getSettings,
    required this.calculateBalances,
    required this.getCurrentYearLeaves,
    required this.getExtraWorkRecords, // 👈 التحديث هنا
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    
    final results = await Future.wait([
      getSettings(const NoParams()),
      calculateBalances(const NoParams()),
      getCurrentYearLeaves(const NoParams()),
      getExtraWorkRecords(const NoParams()), // 👈 التحديث هنا
    ]);

    final settingsResult = results[0] as Either<Failure, Settings>;
    final balanceResult = results[1] as Either<Failure, LeaveBalance>;
    final leavesResult = results[2] as Either<Failure, List<LeaveRecord>>;
    // 👈 التحديث هنا ليطابق الكيان الجديد
    final extraWorkResult = results[3] as Either<Failure, List<ExtraWorkRecord>>; 

    settingsResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (settings) {
        balanceResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (balance) {
            leavesResult.fold(
              (failure) => emit(HomeError(failure.message)),
              (leaves) {
                extraWorkResult.fold(
                  (failure) => emit(HomeError(failure.message)),
                  (extraWorks) {
                    final now = DateTime.now();
                    final currentMonth = now.month;
                    final currentYear = now.year;

                    final monthLeaves = leaves.where((leave) =>
                        leave.startDate.month == currentMonth &&
                        leave.startDate.year == currentYear).toList();
                    
                    // 👈 عرض العمل المكتسب أو المستهلك في الشهر الحالي
                    final monthExtraWorks = extraWorks.where((record) {
                      final isWorkInMonth = !record.isUsed && 
                          record.workStartDate.month == currentMonth && 
                          record.workStartDate.year == currentYear;
                          
                      final isRestInMonth = record.isUsed && 
                          record.restStartDate != null && 
                          record.restStartDate!.month == currentMonth && 
                          record.restStartDate!.year == currentYear;
                          
                      return isWorkInMonth || isRestInMonth;
                    }).toList();

                    emit(HomeLoaded(
                      settings: settings,
                      balance: balance,
                      currentMonthLeaves: monthLeaves,
                      currentMonthRestAllowances: monthExtraWorks, // 👈 المسمى في State
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