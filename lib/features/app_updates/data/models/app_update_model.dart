import 'package:leave_manager/features/app_updates/domain/entities/app_update_info.dart';

class AppUpdateModel extends AppUpdateInfo {
  const AppUpdateModel({
    required super.updateRequired,
    required super.forceUpdate,
    super.message,
    super.storeUrl,
  });

  factory AppUpdateModel.fromJson(Map<String, dynamic> json) {
    // نتعامل هنا مع الرد القادم من /init-config 
    final isMaintenance = json['is_maintenance'] as bool? ?? false;
    final needsForceUpdate = json['needs_force_update'] as bool? ?? false;
    final needsOptionalUpdate = json['needs_optional_update'] as bool? ?? false;
    
    // الأولوية لرسالة الصيانة، ثم رسالة التحديث
    final displayMessage = isMaintenance 
        ? json['maintenance_message']?.toString() 
        : json['release_notes']?.toString();

    return AppUpdateModel(
      // التطبيق يطلب تحديث إذا كان إجبارياً، اختيارياً، أو في وضع صيانة
      updateRequired: isMaintenance || needsForceUpdate || needsOptionalUpdate,
      // نعتبر وضع الصيانة بمثابة Force Update لأنه يمنع الدخول
      forceUpdate: isMaintenance || needsForceUpdate,
      message: displayMessage,
      storeUrl: json['store_url']?.toString(), // تأكد أن الباكند يرسله إذا لزم الأمر
    );
  }
}