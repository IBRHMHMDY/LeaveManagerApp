import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed; // Nullable لتمكين تعطيل الزر (Disabled state)
  final String label;
  final IconData? icon;
  final Color? foregroundColor;
  final bool isLoading; // للتعامل التلقائي مع حالة التحميل
  final double? width; // للتحكم في عرض الزر

  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.foregroundColor,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? context.colorScheme.primary,
        minimumSize: const Size(64, 48),
        side: BorderSide(
          color: foregroundColor ?? context.colorScheme.primary,
          width: 1.5,
        ),
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
                  style: context.textTheme.titleLarge?.copyWith(
                    color: foregroundColor ?? context.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
    );
  }
}
