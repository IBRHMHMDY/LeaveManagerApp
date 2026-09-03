// lib/features/holidays/presentation/screens/holidays_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/financial_year_calculator.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/holiday_card.dart';
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
              'العطلات الرسمية',
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
                title: 'لا توجد عطلات',
                content: 'لم يتم العثور على عطلات مسجلة.'
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                final isPast = holiday.endDate.isBefore(DateTime.now());
                // وظيفة النقر ستظل تعمل طبيعياً داخل HolidayCard
                return HolidayCard(holiday: holiday, isPast: isPast);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}