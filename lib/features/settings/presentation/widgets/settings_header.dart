// lib/features/settings/presentation/widgets/settings_header.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/features/settings/presentation/widgets/show_about_developer.dart';
import 'package:leave_manager/shared/widgets/buttons/app_icon_button.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

// جعلت الـ Widget يطبق PreferredSizeWidget ليتم استخدامه مباشرة كـ appBar
class SettingsHeader extends StatelessWidget implements PreferredSizeWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAppBar(
      // استخدام actions للأيقونة اليمنى (عن المطور)
      actions: [
         AppIconButton(
          onPressed: () => showAboutDeveloperBottomSheet(context),
          icon: Icons.info_outline_rounded,
        ),
        const SizedBox(width: 8), // مسافة صغيرة من الحافة
      ],
      // استخدام leading للأيقونة اليسرى (المشاركة) - بما أن التطبيق عربي، الـ leading يكون يميناً والـ actions يساراً
      leading: const AppShareButton(buttonType: ShareButtonType.icon),
      // العنوان في المنتصف
      title: 'إعدادات التطبيق', 
      centerTitle: true,
    );
  }

  // تحديد ارتفاع الـ AppBar، 80.0 هو الافتراضي في AppAppBar الخاص بك
  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}