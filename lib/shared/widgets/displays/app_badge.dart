// lib/shared/widgets/displays/app_badge.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppBadge extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBadge({
    super.key, 
    required this.title,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colorScheme.primaryContainer.withAlpha(30),
        borderRadius: AppRadius.xl,
      ),
      child: Text(
        title,
        style: context.textTheme.labelLarge?.copyWith(
          color: textColor ?? context.colorScheme.primary,
        ),
      ),
    );
  }
}