import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/holiday_action_bottomsheet.dart';

class HolidayCard extends StatelessWidget {
  final Holiday holiday;
  final bool isPast;

  const HolidayCard({super.key,required this.holiday, required this.isPast});

  @override
  Widget build(BuildContext context) {
    final cardColor = isPast
        ? context.colorScheme.surfaceContainerHighest.withOpacity(0.4)
        : context.colorScheme.surface;

    final textColor = isPast
        ? context.colorScheme.onSurfaceVariant
        : context.colorScheme.onSurface;

    return InkWell(
      onTap: () => showHolidayActionBottomSheet(context, holiday),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: AppRadius.lg,
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holiday.name,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: textColor,
                      decoration: isPast ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          holiday.startDate.toFullDateRangeString(
                            holiday.endDate,
                          ),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isPast
                    ? context.colorScheme.onSurface.withOpacity(0.06)
                    : context.colorScheme.primary.withOpacity(0.12),
                borderRadius: AppRadius.md,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${holiday.daysCount}',
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isPast
                          ? context.colorScheme.onSurfaceVariant
                          : context.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'أيام',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isPast
                          ? context.colorScheme.onSurfaceVariant
                          : context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
