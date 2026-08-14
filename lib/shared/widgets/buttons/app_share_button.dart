// lib/shared/widgets/buttons/share_app_button.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/share_service.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

enum ShareButtonType { icon, listTile, outline }

/// ويدجت مشاركة التطبيق متوافقة مع معايير 2026 (إعادة الاستخدام بمرونة)
class AppShareButton extends StatelessWidget {
  final ShareButtonType buttonType;

  const AppShareButton({
    super.key,
    this.buttonType = ShareButtonType.icon, // القيمة الافتراضية
  });

  @override
  Widget build(BuildContext context) {
    if (buttonType == ShareButtonType.icon) {
      return IconButton(
        icon: const Icon(Icons.share_rounded),
        tooltip: 'مشاركة التطبيق',
        onPressed: _handleShareApp,
      );
    }

    if (buttonType == ShareButtonType.outline) {
      return AppOutlinedButton(
        label:  'مشاركة التطبيق',
        icon: Icons.share_rounded,
        foregroundColor: context.colorScheme.primary,
        onPressed: _handleShareApp,
      );
    }

    return ListTile(
      leading: const Icon(Icons.share_rounded),
      title: const Text('مشاركة التطبيق'),
      onTap: _handleShareApp,
    );
  }

  Future<void> _handleShareApp() async {
    final shareService = sl<ShareService>();
    await shareService.shareAppLink(
      appUrl: 'https://play.google.com/store/apps/details?id=com.ibrahimhamdy.leavemanager',
      message: 'نظم إجازاتك وبدلاتك بسهولة مع تطبيق Leave Manager!',
    );
  }
}