// lib/features/rest_allowances/presentation/blocs/rest_allowances_state.dart
import 'package:equatable/equatable.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';

abstract class RestAllowancesState extends Equatable {
  const RestAllowancesState();
  
  @override
  List<Object?> get props => [];
}

class RestAllowancesInitial extends RestAllowancesState {}

class RestAllowancesLoading extends RestAllowancesState {}

class RestAllowancesLoaded extends RestAllowancesState {
  // القوائم المنفصلة كما طلبت
  final List<ExtraWorkRecord> extrawork; // السجلات المتاحة (isUsed == false)
  final List<ExtraWorkRecord> rest;      // السجلات المستهلكة (isUsed == true)
  
  // مجاميع الأرصدة
  final int availables; // إجمالي الأيام المتاحة
  final int usage;      // إجمالي الأيام المستهلكة

  const RestAllowancesLoaded({
    required this.extrawork,
    required this.rest,
    required this.availables,
    required this.usage,
  });

  @override
  List<Object?> get props => [
        extrawork,
        rest,
        availables,
        usage,
      ];
}

class RestAllowancesError extends RestAllowancesState {
  final String message;

  const RestAllowancesError(this.message);

  @override
  List<Object?> get props => [message];
}

class RestAllowanceActionSuccess extends RestAllowancesState {
  final String message;

  const RestAllowanceActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}