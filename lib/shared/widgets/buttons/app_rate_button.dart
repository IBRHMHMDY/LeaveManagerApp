// lib/shared/widgets/buttons/app_rate_button.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/store_launcher_service.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class AppRateButton extends StatelessWidget {
  final String appId;

  const AppRateButton({
    super.key,
    this.appId = 'com.ibrahimhamdy.leavemanager',
  });

  
  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      label: 'تقييم التطبيق',
      icon: Icons.star_rate_rounded,
      backgroundColor: context.colorScheme.secondary,
      foregroundColor: context.colorScheme.onSurfaceVariant,
      onPressed: ()=> StoreLauncherService().launchPlayStore(appId: appId)
    );
  }
}