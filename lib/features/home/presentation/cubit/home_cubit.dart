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
  // [إضافة] UseCase الخاص ببدلات الراحة
  final GetRestAllowancesUseCase getRestAllowances;

  HomeCubit({
    required this.getSettings,
    required this.calculateBalances,
    required this.getCurrentYearLeaves,
    required this.getRestAllowances,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    // [معايير AMD 2026]: جلب البيانات بالتوازي (Concurrency)
    final results = await Future.wait([
      getSettings(const NoParams()),
      calculateBalances(const NoParams()),
      getCurrentYearLeaves(const NoParams()),
      getRestAllowances(const NoParams()), // جلب الراحات
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

                    // تصفية الإجازات العادية للشهر الحالي
                    final monthLeaves = leaves.where((leave) =>
                        leave.startDate.month == currentMonth &&
                        leave.startDate.year == currentYear).toList();

                    // [إضافة] تصفية بدلات الراحة المستهلكة للشهر الحالي
                    final monthRestAllowances = allowances.where((allowance) {
                      if (allowance.isAvailable || allowance.consumedDate == null) return false;
                      return allowance.consumedDate!.month == currentMonth &&
                             allowance.consumedDate!.year == currentYear;
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