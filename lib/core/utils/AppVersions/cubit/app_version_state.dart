import 'package:equatable/equatable.dart';

abstract class AppVersionState extends Equatable {
  const AppVersionState();

  @override
  List<Object> get props => [];
}

class AppVersionInitial extends AppVersionState {}

class AppVersionLoading extends AppVersionState {}

class AppVersionLoaded extends AppVersionState {
  final String version;

  const AppVersionLoaded({required this.version});

  @override
  List<Object> get props => [version];
}