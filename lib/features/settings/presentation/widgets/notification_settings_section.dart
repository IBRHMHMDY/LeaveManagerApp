// lib/features/settings/presentation/widgets/notification_settings_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/inputs/app_number_counter.dart';

class NotificationSettingsSection extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final int daysBefore;
  final ValueChanged<int> onDaysChanged;

  const NotificationSettingsSection({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    required this.daysBefore,
    required this.onDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إعدادات الإشعارات',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          // تصميم متناسق مع ThemeSelectionSection
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(color: context.colorScheme.outline.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              // زر تفعيل/إلغاء الإشعارات
              SwitchListTile(
                title: Text(
                  'إشعارات العطلات الرسمية',
                  style: context.textTheme.titleMedium,
                ),
                subtitle: Text(
                  'الحصول على تنبيهات استباقية وتفاعلية للعطلات',
                  style: context.textTheme.bodySmall,
                ),
                secondary: Icon(
                  isEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                  color: context.colorScheme.primary,
                ),
                value: isEnabled,
                onChanged: onToggle,
              ),
              
              // يظهر فقط إذا كانت الإشعارات مفعلة
              if (isEnabled) ...[
                Divider(color: context.colorScheme.outline.withOpacity(0.1), height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: AppCounterBox(
                    label: 'عدد الأيام قبل العطلة للتنبيه',
                    value: daysBefore,
                    min: 1, // الحد الأدنى للتنبيه قبلها بيوم
                    max: 7, // الحد الأقصى للتنبيه قبلها بأسبوع
                    onChanged: onDaysChanged,
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