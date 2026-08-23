// lib/features/settings/presentation/widgets/settings_header.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/features/settings/presentation/widgets/about_developer_bottomsheet.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class SettingsHeader extends StatelessWidget implements PreferredSizeWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAppBar(
      actions: [
         AppIconButton(
          onPressed: () => showAboutDeveloperBottomSheet(context),
          icon: Icons.info_outline_rounded,
        ),
        const SizedBox(width: 8),
      ],
      title: 'إعدادات التطبيق', 
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}