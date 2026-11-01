// lib/features/app_updates/domain/entities/app_update_info.dart

import 'package:equatable/equatable.dart';

class AppUpdateInfo extends Equatable {
  final bool updateRequired;
  final bool forceUpdate;
  final String? message;
  final String? storeUrl;

  const AppUpdateInfo({
    required this.updateRequired,
    required this.forceUpdate,
    this.message,
    this.storeUrl,
  });

  @override
  List<Object?> get props => [updateRequired, forceUpdate, message, storeUrl];
}