// lib/features/settings/presentation/widgets/notification_settings_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/features/settings/presentation/widgets/battery_optimization_section.dart';
import 'package:leave_manager/shared/widgets/buttons/app_outlined_button.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

class NotificationSettingsSection extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const NotificationSettingsSection({
    super.key,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('إعدادات الإشعارات', style: context.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(0.15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SwitchListTile(
                title: Text(
                  'تفعيل الإشعارات',
                  style: context.textTheme.titleMedium,
                ),
                subtitle: Text(
                  'الحصول على تنبيهات قبل الإجازات الرسمية',
                  style: context.textTheme.bodySmall,
                ),
                secondary: Icon(
                  isEnabled
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_off_rounded,
                  color: context.colorScheme.primary,
                ),
                value: isEnabled,
                onChanged: onToggle,
              ),
              const Divider(),
              // --- Battery Optimization (تحسين البطارية) ---
              const BatteryOptimizationSection(),
              
              // --- زر اختبار الإشعارات (يظهر فقط عند تفعيل الإشعارات) ---
              if (isEnabled) ...[
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: AppOutlinedButton(
                    label: 'اختبار الإشعارات (بعد 5 ثوانٍ)',
                    icon: Icons.timer_outlined,
                    foregroundColor: context.colorScheme.primary,
                    onPressed: () async {
                      AppToast.showSuccess(
                        context, 
                        'سيصلك إشعار بعد 5 ثوانٍ.. جرب إغلاق التطبيق!',
                      );
                      
                      // استدعاء الخدمة مباشرة عبر Dependency Injection
                      await sl<NotificationService>().scheduleDelayedNotification(
                        id: 9999, // معرف عشوائي للاختبار
                        title: 'تجربة الإشعارات نجحت 🚀',
                        body: 'نظام الإشعارات يعمل بنجاح في الخلفية!',
                        delay: const Duration(seconds: 5),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}