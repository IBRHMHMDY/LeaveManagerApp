import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed; // Nullable لتمكين تعطيل الزر (Disabled state)
  final IconData? icon;
  const AppIconButton({super.key, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
    );
  }
}
