// lib/features/holidays/presentation/widgets/upcoming_holiday_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/string_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';

class UpcomingHolidayCard extends StatelessWidget {
  final Holiday? upcomingHoliday;

  const UpcomingHolidayCard({super.key, this.upcomingHoliday});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(AppRouter.holidays);
      },
      borderRadius: AppRadius.lg,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: context.isDarkMode 
                ? context.colorScheme.outline.withOpacity(0.15) 
                : context.colorScheme.primary.withOpacity(0.2),
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
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withAlpha(60),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notification_important,
                color: context.colorScheme.onSurface,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (upcomingHoliday != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withOpacity(0.08),
                        borderRadius: AppRadius.xl,
                      ),
                      child: Text(
                        upcomingHoliday!.daysLeft.remainingDaysText,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: context.colorScheme.primary,
                          fontSize: 12
                        ),
                      ),
                    ),
                  if (upcomingHoliday != null) ...[
                    Text(
                      upcomingHoliday!.name,
                      style: context.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      upcomingHoliday!.startDate.toFormatFullDaysDate(),
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else ...[
                    Text(
                      'لا توجد عطلات قادمة قريباً',
                      style: context.textTheme.titleMedium,
                    ),
                  ],
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