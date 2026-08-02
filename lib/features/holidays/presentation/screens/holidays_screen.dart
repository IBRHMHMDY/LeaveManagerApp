// lib/features/holidays/presentation/screens/holidays_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:intl/intl.dart';

class HolidaysScreen extends StatelessWidget {
  const HolidaysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العطلات الرسمية'), centerTitle: true),
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
              return Center(
                child: Text(
                  'لا توجد عطلات مسجلة',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(AppSpacing.md),
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

  Widget _buildHolidayCard(BuildContext context, holiday, bool isPast) {
    final cardColor = isPast
        ? context.colorScheme.surfaceContainerHighest.withOpacity(0.4)
        : context.colorScheme.surface;
        
    final textColor = isPast
        ? context.colorScheme.onSurfaceVariant
        : context.colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: AppRadii.lg,
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
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        _formatDateRange(holiday.startDate, holiday.endDate),
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
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isPast
                  ? context.colorScheme.onSurface.withOpacity(0.06)
                  : context.colorScheme.primary.withOpacity(0.12),
              borderRadius: AppRadii.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${holiday.daysCount}',
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: isPast ? context.colorScheme.onSurfaceVariant : context.colorScheme.primary,
                  ),
                ),
                Text(
                  'أيام',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: isPast ? context.colorScheme.onSurfaceVariant : context.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final format = DateFormat('d MMM yyyy', 'ar');
    if (start.isAtSameMomentAs(end)) {
      return format.format(start);
    }
    return '${format.format(start)} - ${format.format(end)}';
  }
}