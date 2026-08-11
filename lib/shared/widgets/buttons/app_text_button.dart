import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppTextButton extends StatelessWidget {
  final VoidCallback? onPressed; // Nullable لتمكين تعطيل الزر (Disabled state)
  final String label;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading; // للتعامل التلقائي مع حالة التحميل
  final double? width; // للتحكم في عرض الزر

  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: foregroundColor ?? context.colorScheme.primary,
        minimumSize: const Size(64, 48),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),
      child: isLoading
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: foregroundColor ?? context.colorScheme.onPrimary,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: foregroundColor ?? context.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
    );
  }
}
