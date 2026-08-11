// lib/shared/widgets/buttons/app_floating_button.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

enum _FloatingType { iconOnly, extended }

class AppFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final _FloatingType _type;

  /// مُنشئ للزر العائم الدائري (أيقونة فقط)
  const AppFloatingButton.icon({
    super.key,
    required this.onPressed,
    required IconData this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  })  : _type = _FloatingType.iconOnly,
        label = null;

  /// مُنشئ للزر العائم الممتد (أيقونة ونص)
  const AppFloatingButton.extended({
    super.key,
    required this.onPressed,
    required String this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
  })  : _type = _FloatingType.extended;

  @override
  Widget build(BuildContext context) {
    // تحديد الألوان مع دعم الـ ThemeExtension الافتراضي
    final bgColor = backgroundColor ?? context.colorScheme.primary;
    final fgColor = foregroundColor ?? context.colorScheme.onPrimary;

    if (_type == _FloatingType.extended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        tooltip: tooltip,
        icon: icon != null ? Icon(icon) : null,
        label: Text(
          label!, // آمن تماماً بفضل الـ Named Constructor
          style: context.textTheme.labelLarge?.copyWith(color: fgColor),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      tooltip: tooltip ?? label,
      child: Icon(icon!), // آمن تماماً
    );
  }
}