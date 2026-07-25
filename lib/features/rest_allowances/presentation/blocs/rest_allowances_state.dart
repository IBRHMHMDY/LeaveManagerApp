import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/rest_allowance_entity.dart';

abstract class RestAllowancesState extends Equatable {
  const RestAllowancesState();

  @override
  List<Object?> get props => [];
}

class RestAllowancesInitial extends RestAllowancesState {}

class RestAllowancesLoading extends RestAllowancesState {}

/// الحالة الناجحة التي تحتوي على جميع القوائم والأرصدة جاهزة للعرض
class RestAllowancesLoaded extends RestAllowancesState {
  final List<RestAllowance> availableAllowances;
  final List<RestAllowance> consumedAllowances;
  final int totalAvailable;
  final int totalConsumed;

  const RestAllowancesLoaded({
    required this.availableAllowances,
    required this.consumedAllowances,
    required this.totalAvailable,
    required this.totalConsumed,
  });

  @override
  List<Object?> get props => [
        availableAllowances,
        consumedAllowances,
        totalAvailable,
        totalConsumed,
      ];
}

/// حالة الفشل تعرض رسالة الخطأ القادمة من الـ Failure
class RestAllowancesError extends RestAllowancesState {
  final String message;

  const RestAllowancesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// حالة مخصصة لنجاح العمليات (إضافة، تعديل، حذف) لعرض Toast للمستخدم
class RestAllowanceActionSuccess extends RestAllowancesState {
  final String message;

  const RestAllowanceActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}