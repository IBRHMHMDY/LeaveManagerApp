// lib/features/app_updates/presentation/screens/force_update_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extensions/theme_extension.dart';
import 'package:leave_manager/core/utils/store_launcher_service.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class ForceUpdateScreen extends StatelessWidget {
  final String? message;

  const ForceUpdateScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // يمنع زر الرجوع في الأندرويد من تخطي الشاشة
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.system_update_rounded,
                  size: 100,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'تحديث جديد متاح!',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  message ?? 'لقد أطلقنا إصداراً جديداً من التطبيق يحتوي على ميزات جديدة وتحسينات هامة. يرجى التحديث للمتابعة.',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppPrimaryButton(
                  label: 'تحديث الآن',
                  icon: Icons.download_rounded,
                  onPressed: () {
                    StoreLauncherService().launchPlayStore(
                      appId: 'com.ibrahimhamdy.leavemanager',
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextButton(
                  label: 'الخروج من التطبيق',
                  foregroundColor: context.colorScheme.error,
                  onPressed: () => SystemNavigator.pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}