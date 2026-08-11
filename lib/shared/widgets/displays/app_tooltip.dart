// lib/shared/widgets/displays/app_tooltip.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final bool preferBelow;
  final Duration waitDuration;

  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = false,
    this.waitDuration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      waitDuration: waitDuration,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.inverseSurface,
        borderRadius: AppRadius.sm,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: context.textTheme.labelMedium?.copyWith(
        color: context.colorScheme.onInverseSurface,
      ),
      child: child,
    );
  }
}