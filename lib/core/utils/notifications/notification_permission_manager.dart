// lib/core/utils/notifications/notification_permission_manager.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/utils/notifications/fcm_service.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/shared/widgets/overlays/app_confirm_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class NotificationPermissionManager {
  final NotificationService _localNotificationService;
  final FCMService _fcmService;

  NotificationPermissionManager(
    this._localNotificationService,
    this._fcmService,
  );

  /// تعرض الدالة مربع حوار مخصص لإعلام المستخدم،
  /// وتتعامل مع حالات النظام (السماح، الرفض، الرفض النهائي).
  Future<bool> requestPermissionsWithDialog(BuildContext context) async {
    // 1. التحقق من حالة الصلاحية الحالية من النظام
    PermissionStatus status = await Permission.notification.status;
    // إضافة: تخطي النوافذ إذا كانت الصلاحية ممنوحة بالفعل
    if (status.isGranted) {
      await _localNotificationService.requestPermissions();
      await _fcmService.requestPermissions();
      return true;
    }
    // إذا كانت الصلاحية مرفوضة نهائياً في النظام (لن يظهر مربع النظام)
    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        return await _handlePermanentlyDenied(context);
      }
    }

    // 2. إظهار مربع الحوار التوضيحي (Custom Dialog) الخاص بك
    if (context.mounted) {
      final shouldRequest = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AppConfirmDialog(
            title: 'تفعيل الإشعارات',
            content:
                'هل ترغب في تفعيل الإشعارات لتصلك تنبيهات العطلات والمناسبات القادمة؟',
            confirmText: 'موافق',
            cancelText: 'تجاهل',
            onConfirm: () => dialogContext.pop(true),
          );
        },
      );
      // 3. إذا وافق المستخدم، نطلب الصلاحية الفعلية من النظام
      if (shouldRequest == true) {
        // هذا الأمر هو المسؤول عن إظهار نافذة (Allow / Deny) الخاصة بالنظام
        status = await Permission.notification.request();

        if (status.isGranted) {
          // تفعيل خدمات الإشعارات المحلية و FCM بعد موافقة النظام
          await _localNotificationService.requestPermissions();
          await _fcmService.requestPermissions();
          return true;
        } else if (status.isPermanentlyDenied) {
          // إذا ضغط "Deny" مرتين (حظرها النظام)، نوجهه للإعدادات
           if (context.mounted){
            return await _handlePermanentlyDenied(context);
           }
        }
      }
    }
    return false; // المستخدم تجاهل أو رفض الصلاحية
  }

  /// دالة مساعدة لتوجيه المستخدم لإعدادات التطبيق إذا كانت الصلاحية محظورة
  Future<bool> _handlePermanentlyDenied(BuildContext context) async {
    final openSettings = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppConfirmDialog(
          title: 'صلاحية الإشعارات مطلوبة',
          content:
              'تم إيقاف صلاحية الإشعارات من إعدادات النظام. يرجى تفعيلها من إعدادات الهاتف لتتمكن من استلام التنبيهات.',
          confirmText: 'الذهاب للإعدادات',
          cancelText: 'إلغاء',
          onConfirm: () => dialogContext.pop(true),
        );
      },
    );

    if (openSettings == true) {
      // فتح إعدادات التطبيق داخل النظام
      await openAppSettings();
    }

    // التحقق مرة أخرى بعد عودة المستخدم من شاشة الإعدادات
    final status = await Permission.notification.status;
    if (status.isGranted) {
      await _localNotificationService.requestPermissions();
      await _fcmService.requestPermissions();
      return true;
    }

    return false;
  }
}
