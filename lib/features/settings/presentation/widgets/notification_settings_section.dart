// lib/features/settings/presentation/widgets/notification_settings_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/inputs/app_counter_row.dart';

class NotificationSettingsSection extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final int daysBefore;
  final ValueChanged<int> onDaysChanged;
  final String notificationTime; // [إضافة]
  final ValueChanged<String> onTimeChanged; // [إضافة]

  const NotificationSettingsSection({
    super.key,
    required this.isEnabled,
    required this.onToggle,
    required this.daysBefore,
    required this.onDaysChanged,
    required this.notificationTime,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    // تحليل الوقت الحالي لتعيينه كقيمة مبدئية
    final timeParts = notificationTime.split(':');
    int hour = 10;
    int minute = 0;
    if (timeParts.length == 2) {
      hour = int.tryParse(timeParts[0]) ?? 10;
      minute = int.tryParse(timeParts[1]) ?? 0;
    }

    final initialTime = TimeOfDay(hour: hour, minute: minute);
    
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          // دمج مظهر التطبيق (Theme) ليتناسب مع الـ TimePicker
          data: context.theme.copyWith(
            colorScheme: context.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && context.mounted) {
      // تنسيق الوقت بصيغة HH:mm للحفظ في قاعدة البيانات
      final formattedTime = 
          '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
      onTimeChanged(formattedTime);
    }
  }

  String _formatTimeForDisplay(BuildContext context) {
    final timeParts = notificationTime.split(':');
    if (timeParts.length != 2) return notificationTime;
    final hour = int.tryParse(timeParts[0]) ?? 10;
    final minute = int.tryParse(timeParts[1]) ?? 0;
    
    return TimeOfDay(hour: hour, minute: minute).format(context);
  }

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
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(color: context.colorScheme.outline.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  'تفعيل التنبيهات',
                  style: context.textTheme.titleMedium,
                ),
                subtitle: Text(
                  'تلقي إشعارات قبل بدء الإجازات والعطلات',
                  style: context.textTheme.bodySmall,
                ),
                secondary: Icon(
                  isEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                  color: context.colorScheme.primary,
                ),
                value: isEnabled,
                onChanged: onToggle,
              ),
              if (isEnabled) ...[
                Divider(color: context.colorScheme.outline.withOpacity(0.1), height: 1),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: AppCounterRow(
                    label: 'تنبيه قبل العطله ',
                    value: daysBefore,
                    min: 1,
                    max: 7,
                    onChanged: onDaysChanged,
                    afterCounter: 'يوم/أيام',
                  ),
                ),

                Divider(color: context.colorScheme.outline.withOpacity(0.1), height: 1),
                // [إضافة] واجهة اختيار الوقت
                ListTile(
                  leading: Icon(
                    Icons.access_time_rounded,
                    color: context.colorScheme.primary,
                  ),
                  title: Text(
                    'وقت التنبيه المفضل',
                    style: context.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    _formatTimeForDisplay(context),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Icon(
                    Icons.edit_rounded,
                    color: context.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  onTap: () => _selectTime(context),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}