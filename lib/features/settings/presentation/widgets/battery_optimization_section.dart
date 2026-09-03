// lib/features/settings/presentation/widgets/battery_optimization_section.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/notifications/background_permissions_helper.dart';

class BatteryOptimizationSection extends StatelessWidget {
  const BatteryOptimizationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ListTile(
          leading: Icon(
            Icons.battery_saver_rounded,
            color: context.colorScheme.secondary,
          ),
          title: Text(
            'إعدادات الخلفية والإشعارات',
            style: context.textTheme.titleMedium,
          ),
          subtitle: Text(
            'تحسين البطارية والتشغيل التلقائي لضمان وصول التنبيهات',
            style: context.textTheme.bodySmall?.copyWith(
              height: 1.4,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: context.colorScheme.onSurfaceVariant,
          ),
          // استدعاء التسلسل من فئة الـ Helper المستقلة
          onTap: () => BackgroundPermissionsHelper.showBatteryAndAutostartGuidance(context),
        ),
      ],
    );
  }
}