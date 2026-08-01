// lib/shared/widgets/custom_empty_state.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy_rounded, // استخدام الأيقونات الدائرية لتوحيد النمط
              size: 80,
              color: colorScheme.outlineVariant, // لون هادئ ومتوافق مع النمطين
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              titleEmpty,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              contentEmpty,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}