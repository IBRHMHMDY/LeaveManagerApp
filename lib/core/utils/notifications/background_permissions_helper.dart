// lib/core/utils/notifications/background_permissions_helper.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:leave_manager/shared/widgets/overlays/app_confirm_dialog.dart';

abstract final class BackgroundPermissionsHelper {
  /// يعرض حوار تحسين البطارية، يليه مباشرة حوار التشغيل التلقائي
  static Future<void> showBatteryAndAutostartGuidance(BuildContext context) async {
    // 1. عرض حوار تحسين البطارية (Battery Optimization)
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppConfirmDialog(
          title: 'إعدادات البطارية',
          content: 'لضمان عمل إشعارات الإجازات بدقة:\n\n'
              '1. انتقل إلى إعدادات التطبيق.\n'
              '2. اختر "البطارية" (Battery).\n'
              '3. اختر "بدون قيود" (Unrestricted).\n\n'
              'هل تريد الانتقال للإعدادات الآن؟',
          confirmText: 'الذهاب للإعدادات',
          cancelText: 'إلغاء',
          onConfirm: () async {
            Navigator.of(dialogContext).pop(true);
            await openAppSettings();
          },
        );
      },
    );

    // التحقق من Context لتجنب Memory Leaks بعد انتظار الـ Dialog الأول
    if (!context.mounted) return;

    // تأخير زمني بسيط (300ms) لضمان انتهاء حركة إغلاق الحوار الأول بسلاسة قبل فتح الثاني
    await Future.delayed(const Duration(milliseconds: 300));

    if (!context.mounted) return;

    // 2. عرض حوار التشغيل التلقائي (AutoStart)
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppConfirmDialog(
          title: 'التشغيل التلقائي (AutoStart)',
          content: 'في بعض الأجهزة (مثل Xiaomi, Oppo, Vivo)، يجب تفعيل "التشغيل التلقائي" '
              'للسماح للتطبيق بالعمل في الخلفية وتحديث الإجازات.\n\n'
              'يرجى التأكد من تفعيل هذا الخيار من إعدادات التطبيق.',
          confirmText: 'تفعيل الآن',
          cancelText: 'تخطي',
          onConfirm: () async {
            Navigator.of(dialogContext).pop(true);
            await openAppSettings();
          },
        );
      },
    );
  }
}