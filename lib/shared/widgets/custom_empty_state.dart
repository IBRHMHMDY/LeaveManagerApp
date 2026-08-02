// lib/shared/widgets/custom_empty_state.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class CustomEmptyState extends StatelessWidget {
  final String titleEmpty;
  final String contentEmpty;

  const CustomEmptyState({
    super.key,
    required this.titleEmpty,
    required this.contentEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded, 
              size: 80,
              color: context.colorScheme.outlineVariant, 
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              titleEmpty,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              contentEmpty,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}