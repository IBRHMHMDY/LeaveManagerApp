// lib/shared/widgets/buttons/app_rate_button.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AppRateButton extends StatelessWidget {
  final String appId;

  const AppRateButton({
    super.key,
    this.appId = 'com.ibrahimhamdy.leavemanager',
  });

  Future _launchStore() async {
    final Uri playStoreUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$appId',
    );

    if (!await launchUrl(playStoreUri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch Play Store link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: 'تقييم التطبيق بخمس نجوم',
      icon: Icons.star_rate_rounded,
      backgroundColor: context.colorScheme.secondary,
      foregroundColor: context.colorScheme.onSecondary,
      onPressed: _launchStore,
    );
  }
}