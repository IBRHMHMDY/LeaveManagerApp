import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class CustomBadge extends StatelessWidget {
  final String titleBadge;
  const CustomBadge({super.key, required this.titleBadge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadii.xl,
        border: Border.all(color: context.colorScheme.onPrimary, width: 0.5),
      ),
      child: Text(
        titleBadge,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}