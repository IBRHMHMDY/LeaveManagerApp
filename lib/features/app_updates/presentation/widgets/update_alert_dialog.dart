// lib/features/app_updates/presentation/widgets/update_alert_dialog.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extensions/theme_extension.dart';
import 'package:leave_manager/core/utils/store_launcher_service.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateAlertDialog extends StatelessWidget {
  final String? message;
  final VoidCallback onSkip;

  const UpdateAlertDialog({
    super.key,
    this.message,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    // نستخدم PopScope لمنع إغلاق الـ Dialog بالضغط على زر الرجوع 
    // دون المرور بدالة onSkip لضمان استمرار دورة حياة التطبيق.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop();
        onSkip();
      },
      child: AlertDialog(
        backgroundColor: context.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lg),
        title: Row(
          children: [
            Icon(
              Icons.system_update_rounded,
              color: context.colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'تحديث متوفر',
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          message ?? 'يتوفر إصدار جديد من التطبيق يحتوي على تحسينات إضافية. هل تود التحديث الآن؟',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          AppTextButton(
            label: 'لاحقاً',
            foregroundColor: context.colorScheme.onSurfaceVariant,
            onPressed: () {
              context.pop();
              onSkip(); // إكمال دورة حياة التطبيق (الذهاب للرئيسية)
            },
          ),
          AppPrimaryButton(
            label: 'تحديث',
            onPressed: () async{
              context.pop();
              final packageInfo = await PackageInfo.fromPlatform();
              StoreLauncherService().launchPlayStore(
                appId: packageInfo.packageName,
              );
              onSkip(); // إكمال الدخول للتطبيق بعد تحويله للمتجر
            },
          ),
        ],
      ),
    );
  }
}