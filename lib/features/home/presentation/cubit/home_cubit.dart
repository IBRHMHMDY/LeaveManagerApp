import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/get_settings_usecase.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetSettingsUseCase getSettings;
  final CalculateBalancesUseCase calculateBalances;
  final GetCurrentYearLeavesUseCase getCurrentYearLeaves;

  HomeCubit({
    required this.getSettings,
    required this.calculateBalances,
    required this.getCurrentYearLeaves,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    // التنفيذ المتوازي لتحسين الأداء (Concurrency)
    final results = await Future.wait([
      getSettings(const NoParams()),
      calculateBalances(const NoParams()),
      getCurrentYearLeaves(const NoParams()),
    ]);

    // معالجة النتائج
    final settingsResult = results[0] as dynamic;
    final balanceResult = results[1] as dynamic;
    final leavesResult = results[2] as dynamic;

    settingsResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (settings) {
        balanceResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (balance) {
            leavesResult.fold(
              (failure) => emit(HomeError(failure.message)),
              (leaves) {
                // تصفية إجازات الشهر الحالي فقط
                final now = DateTime.now();
                final currentMonth = now.month;
                final currentYear = now.year;
                
                final monthLeaves = leaves.where((leave) => 
                  leave.startDate.month == currentMonth && 
                  leave.startDate.year == currentYear
                ).toList();

                emit(HomeLoaded(
                  settings: settings,
                  balance: balance,
                  currentMonthLeaves: monthLeaves,
                ));
              },
            );
          },
        );
      },
    );
  }
}