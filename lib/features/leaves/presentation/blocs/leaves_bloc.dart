import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_balance_entity.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/features/leaves/domain/usecases/add_leave_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/calculate_balances_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/delete_leave_usecase.dart';
import 'package:leave_manager/features/leaves/domain/usecases/get_current_year_leaves_usecase.dart';
import 'package:leave_manager/features/settings/domain/usecases/settings_usecase.dart';


// --- Events ---
abstract class LeavesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadBalancesAndLeavesEvent extends LeavesEvent {}

class AddNewLeaveEvent extends LeavesEvent {
  final LeaveRecord leave;
  AddNewLeaveEvent(this.leave);
  @override
  List<Object> get props => [leave];
}

class ResetAllLeavesEvent extends LeavesEvent {}

class DeleteLeaveEvent extends LeavesEvent {
  final int leaveId;
  DeleteLeaveEvent(this.leaveId);
  @override
  List<Object> get props => [leaveId];
}

// --- States ---
abstract class LeavesState extends Equatable {
  @override
  List<Object> get props => [];
}

class LeavesInitial extends LeavesState {}

class LeavesLoading extends LeavesState {}

class LeavesLoaded extends LeavesState {
  final LeaveBalance balance;
  final List<LeaveRecord> currentYearLeaves;

  LeavesLoaded({required this.balance, required this.currentYearLeaves});

  @override
  List<Object> get props => [balance, currentYearLeaves];
}

class LeaveAddedSuccess extends LeavesState {}

class LeavesError extends LeavesState {
  final String message;
  LeavesError(this.message);
  @override
  List<Object> get props => [message];
}

class LeavesResetSuccess extends LeavesState {}

class LeaveDeletedSuccess extends LeavesState {}

// --- BLoC ---
class LeavesBloc extends Bloc<LeavesEvent, LeavesState> {
  final CalculateBalancesUseCase calculateBalances;
  final GetCurrentYearLeavesUseCase getCurrentYearLeaves;
  final AddLeaveUseCase addLeave;
  final ResetBalancesUseCase resetLeaves;
  final DeleteLeaveUseCase deleteLeave;
  LeavesBloc({
    required this.calculateBalances,
    required this.getCurrentYearLeaves,
    required this.addLeave,
    required this.resetLeaves,
    required this.deleteLeave,
  }) : super(LeavesInitial()) {
    on<LoadBalancesAndLeavesEvent>((event, emit) async {
      emit(LeavesLoading());

      // جلب الأرصدة
      final balanceResult = await calculateBalances(const NoParams());
      // جلب السجلات
      final leavesResult = await getCurrentYearLeaves(const NoParams());

      balanceResult.fold((failure) => emit(LeavesError(failure.message)), (
        balance,
      ) {
        leavesResult.fold(
          (failure) => emit(LeavesError(failure.message)),
          (leaves) =>
              emit(LeavesLoaded(balance: balance, currentYearLeaves: leaves)),
        );
      });
    });

    on<AddNewLeaveEvent>((event, emit) async {
      // 1. الاحتفاظ بحالة وبيانات الشاشة الحالية قبل محاولة الحفظ
      LeaveBalance? currentBalance;
      List<LeaveRecord>? currentLeaves;

      if (state is LeavesLoaded) {
        currentBalance = (state as LeavesLoaded).balance;
        currentLeaves = (state as LeavesLoaded).currentYearLeaves;
      }

      emit(LeavesLoading()); // لتشغيل مؤشر التحميل داخل الزر
      final result = await addLeave(event.leave);

      result.fold(
        (failure) {
          // 2. إطلاق حالة الخطأ (لكي تلتقطها الواجهة وتظهر SnackBar وتغلق النافذة)
          emit(LeavesError(failure.message));

          // 3. استعادة حالة الشاشة السابقة فوراً لإخفاء الـ Circular Progress
          if (currentBalance != null && currentLeaves != null) {
            emit(
              LeavesLoaded(
                balance: currentBalance,
                currentYearLeaves: currentLeaves,
              ),
            );
          } else {
            add(LoadBalancesAndLeavesEvent());
          }
        },
        (_) {
          emit(LeaveAddedSuccess());
          add(LoadBalancesAndLeavesEvent());
        },
      );
    });

    on<ResetAllLeavesEvent>((event, emit) async {
      emit(LeavesLoading());
      final result = await resetLeaves(const NoParams());

      result.fold((failure) => emit(LeavesError(failure.message)), (_) {
        emit(LeavesResetSuccess());
        // إعادة تحميل البيانات بعد التصفير
        add(LoadBalancesAndLeavesEvent());
      });
    });

    on<DeleteLeaveEvent>((event, emit) async {
      emit(LeavesLoading());
      final result = await deleteLeave(event.leaveId);

      result.fold(
        (failure) {
          emit(LeavesError(failure.message));
          add(LoadBalancesAndLeavesEvent()); // استعادة البيانات في حالة الخطأ
        },
        (_) {
          emit(LeaveDeletedSuccess());
          add(
            LoadBalancesAndLeavesEvent(),
          ); // إعادة تحميل القائمة والأرصدة فوراً
        },
      );
    });
  }
}
