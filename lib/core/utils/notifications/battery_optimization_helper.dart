import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; //[cite: 2]
import 'package:leave_manager/shared/widgets/overlays/app_confirm_dialog.dart'; //

class BatteryOptimizationHelper {
  static Future<void> checkAndPromptBatterySettings(BuildContext context) async {
    // التحقق مما إذا كان التطبيق يتجاهل تحسين البطارية بالفعل
    final isIgnoring = await Permission.ignoreBatteryOptimizations.isGranted;

    if (!isIgnoring && context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AppConfirmDialog(
          title: 'ضمان وصول الإشعارات',
          content: 'لضمان وصول إشعارات الإجازات في وقتها، يرجى السماح للتطبيق بالعمل في الخلفية من إعدادات البطارية.',
          confirmText: 'الذهاب للإعدادات',
          cancelText: 'تخطي',
          onConfirm: () {
            Navigator.of(ctx).pop();
            // فتح إعدادات التطبيق ليقوم المستخدم بتغييرها يدوياً
            openAppSettings(); 
          },
        ),
      );
    }
  }
}