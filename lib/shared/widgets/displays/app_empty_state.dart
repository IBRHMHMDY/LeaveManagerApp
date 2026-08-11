// lib/shared/widgets/displays/app_empty_state.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppEmptyState extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const AppEmptyState({
    super.key,
    required this.title,
    required this.content,
    this.icon = Icons.event_busy_rounded, // توفير المرونة لتغيير الأيقونة
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: context.colorScheme.outlineVariant,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              content,
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