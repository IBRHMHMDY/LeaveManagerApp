import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed; // Nullable لتمكين تعطيل الزر (Disabled state)
  final IconData? icon;
  const AppIconButton({super.key, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 26, color: context.colorScheme.onSurface,),
    );
  }
}
