// lib/features/home/presentation/widgets/rest_allowances_stats_button.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class RestAllowancesStatsButton extends StatelessWidget {
  const RestAllowancesStatsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final restColor = context.leaveColors.restAllowance;

    return InkWell(
      onTap: () {
        context.go(AppRouter.restAllowances);
      },
      borderRadius: AppRadii.lg,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: restColor.withOpacity(0.2), // بديل withAlpha(50)
            width: 1,
          ),
          boxShadow: [
            if (!context.isDarkMode)
              BoxShadow(
                color: context.colorScheme.shadow.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: restColor.withOpacity(0.8), // بديل withAlpha(200)
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium_rounded,
                color: context.colorScheme.surface,
                size: 28,
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'بدلات الراحه',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'ادارة الاضافى والعطلات',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: context.colorScheme.onSurfaceVariant.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}