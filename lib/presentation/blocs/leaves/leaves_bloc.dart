import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/leave_balance.dart';
import '../../../domain/entities/leave_record.dart';
import '../../../domain/usecases/add_leave_usecase.dart';
import '../../../domain/usecases/calculate_balances_usecase.dart';
import '../../../domain/usecases/get_current_year_leaves_usecase.dart';
import '../../../core/usecases/base_usecase.dart';

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

// --- BLoC ---
class LeavesBloc extends Bloc<LeavesEvent, LeavesState> {
  final CalculateBalancesUseCase calculateBalances;
  final GetCurrentYearLeavesUseCase getCurrentYearLeaves;
  final AddLeaveUseCase addLeave;

  LeavesBloc({
    required this.calculateBalances,
    required this.getCurrentYearLeaves,
    required this.addLeave,
  }) : super(LeavesInitial()) {

    on<LoadBalancesAndLeavesEvent>((event, emit) async {
      emit(LeavesLoading());
      
      // جلب الأرصدة
      final balanceResult = await calculateBalances(const NoParams());
      // جلب السجلات
      final leavesResult = await getCurrentYearLeaves(const NoParams());

      balanceResult.fold(
        (failure) => emit(LeavesError(failure.message)),
        (balance) {
          leavesResult.fold(
            (failure) => emit(LeavesError(failure.message)),
            (leaves) => emit(LeavesLoaded(balance: balance, currentYearLeaves: leaves)),
          );
        },
      );
    });

    on<AddNewLeaveEvent>((event, emit) async {
      emit(LeavesLoading());
      final result = await addLeave(event.leave);
      
      result.fold(
        (failure) => emit(LeavesError(failure.message)),
        (_) {
          emit(LeaveAddedSuccess());
          // إعادة تحميل البيانات تلقائياً بعد إضافة إجازة لتحديث الأرصدة والشاشة
          add(LoadBalancesAndLeavesEvent());
        },
      );
    });
  }
}