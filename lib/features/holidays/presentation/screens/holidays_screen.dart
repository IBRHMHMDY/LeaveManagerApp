// lib/features/holidays/presentation/screens/holidays_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/shared/widgets/displays/app_app_bar.dart';
import 'package:leave_manager/shared/widgets/displays/app_badge.dart';
import 'package:leave_manager/shared/widgets/displays/app_empty_state.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        customTitle: Column(
          children: [
            Text(
              'العطلات الرسميه',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            AppBadge(
              title: FinancialYearCalculator.financialYearString,
              textColor: context.colorScheme.onSurface,
            ),
          ],
        ),
      ),
      body: BlocBuilder<HolidaysCubit, HolidaysState>(
        builder: (context, state) {
          if (state is HolidaysLoading || state is HolidaysInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HolidaysError) {
            return Center(child: Text(state.message));
          }
          if (state is HolidaysLoaded) {
            final holidays = state.financialYearHolidays;
            if (holidays.isEmpty) {
              return const AppEmptyState(
                title: 'فشل فى قراءه العطلات',
                content: 'من فضلك اتصل بالدعم لإصلاح المشكله',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                final isPast = holiday.endDate.isBefore(DateTime.now());
                return _buildHolidayCard(context, holiday, isPast);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHolidayCard(BuildContext context, Holiday holiday, bool isPast) {
    final cardColor = isPast
        ? context.colorScheme.surfaceContainerHighest.withOpacity(0.4)
        : context.colorScheme.surface;

    final textColor = isPast
        ? context.colorScheme.onSurfaceVariant
        : context.colorScheme.onSurface;

    return Container(
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
    );
  }
}
