import 'package:equatable/equatable.dart';
import '../../domain/entities/extra_work_day_entity.dart';

abstract class ExtraWorkState extends Equatable {
  const ExtraWorkState();

  @override
  List<Object?> get props => [];
}

class ExtraWorkInitial extends ExtraWorkState {}

class ExtraWorkLoading extends ExtraWorkState {}

class ExtraWorkLoaded extends ExtraWorkState {
  final List<ExtraWorkDay> extraWorkDays;

  const ExtraWorkLoaded(this.extraWorkDays);

  @override
  List<Object?> get props => [extraWorkDays];
}

class ExtraWorkError extends ExtraWorkState {
  final String message;

  const ExtraWorkError(this.message);

  @override
  List<Object?> get props => [message];
}