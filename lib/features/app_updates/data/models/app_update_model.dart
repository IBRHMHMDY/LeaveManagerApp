// lib/features/app_updates/data/models/app_update_model.dart

import 'package:leave_manager/features/app_updates/domain/entities/app_update_info.dart';

class AppUpdateModel extends AppUpdateInfo {
  const AppUpdateModel({
    required super.updateRequired,
    required super.forceUpdate,
    super.message,
    super.storeUrl,
  });

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) {
    return AppUpdateModel(
      updateRequired: json['update_available'] ?? false,
      forceUpdate: json['is_force_update'] ?? false,
      // أولوية العرض لرسالة الصيانة، ثم ملاحظات الإصدار
      message: json['maintenance_message']?.toString() 
          ?? json['release_notes']?.toString(),
      storeUrl: json['store_url']?.toString(),
    );
  }
}