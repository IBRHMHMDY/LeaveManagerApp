// lib/core/utils/notifications/notification_permission_manager.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/shared/widgets/overlays/app_confirm_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

@lazySingleton
class NotificationPermissionManager {
  final NotificationService _localNotificationService;

  NotificationPermissionManager(
    this._localNotificationService,
  );

  /// طلب صلاحيات الإشعارات مع عرض Dialog توضيحي إذا لزم الأمر
  Future<bool> requestPermissionsWithDialog(BuildContext context) async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      await _executePostPermissionSetup();
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        return await _handlePermanentlyDenied(context);
      }
    }

    if (context.mounted) {
      final shouldRequest = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AppConfirmDialog(
            title: 'تفعيل الإشعارات',
            content: 'نحتاج لصلاحية الإشعارات لتذكيرك بمواعيد إجازاتك والعطلات الرسمية.',
            confirmText: 'تفعيل',
            cancelText: 'تخطي',
            onConfirm: () => dialogContext.pop(true),
          );
        },
      );

      if (shouldRequest == true) {
        status = await Permission.notification.request();

        if (status.isGranted) {
          await _executePostPermissionSetup();
          return true;
        } else if (status.isPermanentlyDenied) {
          if (context.mounted) {
            return await _handlePermanentlyDenied(context);
          }
        }
      }
    }

    return false;
  }

  /// إعدادات ما بعد منح الصلاحية (للإشعارات المحلية فقط)
  Future<void> _executePostPermissionSetup() async {
    try {
      await _localNotificationService.requestPermissions();
    } catch (e) {
      debugPrint('خطأ في إعدادات الإشعارات: $e');
    }
  }

  Future<bool> _handlePermanentlyDenied(BuildContext context) async {
    final openSettings = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AppConfirmDialog(
          title: 'صلاحية مرفوضة',
          content: 'لقد قمت برفض صلاحية الإشعارات مسبقاً. يرجى تفعيلها من إعدادات النظام.',
          confirmText: 'فتح الإعدادات',
          cancelText: 'إلغاء',
          onConfirm: () => dialogContext.pop(true),
        );
      },
    );

    if (openSettings == true) {
      await openAppSettings();
    }

    final status = await Permission.notification.status;
    if (status.isGranted) {
      await _executePostPermissionSetup();
      return true;
    }

    return false;
  }
}