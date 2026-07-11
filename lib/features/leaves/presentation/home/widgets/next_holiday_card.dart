// lib/features/holidays/presentation/widgets/next_holiday_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/extenstions/holiday_extensions.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_bloc.dart';
import 'package:leave_manager/features/holidays/presentation/bloc/holidays_state.dart';


class NextHolidayCard extends StatelessWidget {
  final VoidCallback? onTap;

  const NextHolidayCard({super.key, this.onTap});

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

          final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
          final holidayStart = DateTime(nextHoliday.startDate.year, nextHoliday.startDate.month, nextHoliday.startDate.day);
          final daysLeft = holidayStart.difference(today).inDays;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [colorScheme.surfaceContainerHighest, colorScheme.surface]
                    : [colorScheme.primaryContainer.withAlpha(140), colorScheme.primaryContainer.withAlpha(40)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.primary.withAlpha(40),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias, // مهم لكي لا تخرج تأثيرات الضغط خارج الحواف الدائرية
            child: InkWell(
              onTap: onTap, // تفعيل الضغط إذا تم تمرير الدالة
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(30),
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
                          Text(
                            'الإجازة الرسمية القادمة',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            nextHoliday.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Text(
                          //   nextHoliday.startDate.toFormattedDate(),
                          //   style: TextStyle(
                          //     fontSize: 13,
                          //     color: colorScheme.onSurfaceVariant,
                          //   ),
                          // ),
                          const SizedBox(height: 4),
                          Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getRemainingDaysText(daysLeft),
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                    
                    // القسم الأيسر: الأيام المتبقية
                   

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                           if(onTap != null) const Icon(Icons.arrow_forward_ios_rounded)
                        ],
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