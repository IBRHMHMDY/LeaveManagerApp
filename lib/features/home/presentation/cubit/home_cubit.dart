import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
import 'package:leave_manager/features/rest_allowances/domain/usecases/get_rest_allowances_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
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

    final settingsResult = results[0] as dynamic;
    final balanceResult = results[1] as dynamic;
    final leavesResult = results[2] as dynamic;
    final restAllowancesResult = results[3] as dynamic;

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

                    // التحديث هنا: استخدام الهيكلية الجديدة لفلترة الاستهلاك
                    final monthRestAllowances = allowances.where((allowance) {
                      // استبعاد بدلات الراحة المكتسبة (نريد المستهلكة فقط في هذه القائمة)
                      if (allowance.isEarned) return false;
                      
                      // الاعتماد على startDate بدلاً من consumedDate المحذوف
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