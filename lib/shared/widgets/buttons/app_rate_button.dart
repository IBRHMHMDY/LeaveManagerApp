// lib/shared/widgets/buttons/app_rate_button.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extensions/theme_extension.dart';
import 'package:leave_manager/core/utils/store_launcher_service.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppRateButton extends StatelessWidget {
  const AppRateButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      label: 'تقييم التطبيق',
      icon: Icons.star_rate_rounded,
      backgroundColor: context.colorScheme.secondary,
      foregroundColor: context.colorScheme.onSurfaceVariant,
      onPressed: () async {
        // جلب معرف التطبيق مباشرة
        final packageInfo = await PackageInfo.fromPlatform();
        StoreLauncherService().launchPlayStore(appId: packageInfo.packageName);
      }
    );
  }
}