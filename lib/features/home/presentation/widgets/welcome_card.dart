// lib/app/layout/widgets/welcome_card.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class WelcomeCard extends StatelessWidget {
  final String employeeName;
  final String role;

  const WelcomeCard({
    super.key,
    required this.employeeName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: AppRadius.lg,
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: context.colorScheme.onPrimary,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحبا، $employeeName',
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                AppBadge(title: role),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
