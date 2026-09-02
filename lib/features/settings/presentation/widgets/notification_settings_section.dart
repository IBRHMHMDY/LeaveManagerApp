// lib/features/settings/presentation/widgets/notification_settings_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

/// قسم إعدادات الإشعارات (المبسط لنظام FCM)
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الإشعارات والتنبيهات',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(
              color: context.colorScheme.outline.withOpacity(0.15),
            ),
          ),
          child: SwitchListTile(
            title: Text(
              'تفعيل الاشعارات',
              style: context.textTheme.titleMedium,
            ),
            subtitle: Text(
              'السماح بارسال اشعارات للتنبيهات بالعطلات القادمه',
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
        ),
      ],
    );
  }
}