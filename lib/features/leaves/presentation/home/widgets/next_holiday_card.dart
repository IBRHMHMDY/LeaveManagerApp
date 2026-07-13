import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/extenstions/holiday_extensions.dart';
import 'package:leave_manager/features/app/presentation/bloc/navigation_cubit.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/rest_allowance/holidays/presentation/bloc/holidays_state.dart';

class NextHolidayCard extends StatelessWidget {
  final BuildContext? context;

  const NextHolidayCard(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return BlocBuilder<HolidaysBloc, HolidaysState>(
      builder: (context, state) {
        if (state is HolidaysLoaded) {
          final nextHoliday = state.holidays.nextUpcomingHoliday;

          if (nextHoliday == null) {
            return const SizedBox.shrink();
          }

          final today = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          );
          final holidayStart = DateTime(
            nextHoliday.startDate.year,
            nextHoliday.startDate.month,
            nextHoliday.startDate.day,
          );
          final daysLeft = holidayStart.difference(today).inDays;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 0.8),
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surfaceContainerHighest.withAlpha(140)
                  : colorScheme.primaryContainer.withAlpha(40),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withAlpha(140),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.read<NavigationCubit>().changeTab(
                selectedIndex: 2, // الانتقال لصفحة بدل الراحة في الشريط السفلي
                restAllowanceTab: 2, // فتح تبويب العطلات الرسمية تلقائياً
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(40),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.star_rounded,
                        color: colorScheme.primary,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'الاجازه الرسميه القادمة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                nextHoliday.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withAlpha(40),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _getRemainingDaysText(daysLeft),
                                  style: TextStyle(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  String _getRemainingDaysText(int daysLeft) {
    if (daysLeft == 0) return 'اليوم';
    if (daysLeft == 1) return 'غداً';
    if (daysLeft == 2) return 'بعد غد';
    if (daysLeft <= 10) return 'خلال $daysLeft أيام';
    return 'خلال $daysLeft يوماً';
  }
}
