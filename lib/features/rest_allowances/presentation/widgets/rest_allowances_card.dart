// lib/features/rest_allowances/presentation/widgets/rest_allowances_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/holidays/domain/entities/holiday_entity.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';

class RestAllowancesCard extends StatelessWidget {
  final ExtraWorkRecord extrawork;
  const RestAllowancesCard({super.key, required this.extrawork});

  @override
  Widget build(BuildContext context) {
    final cardColor = context.leaveColors.restAllowance;

    return Dismissible(
      key: ValueKey('extrawork_${extrawork.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colorScheme.error, 
          borderRadius: AppRadii.lg,
        ),
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Icon(Icons.delete_sweep_rounded, color: context.colorScheme.onError, size: 28),
      ),
      confirmDismiss: (direction) async {
        bool confirm = false;
        await showDialog(
          context: context,
          builder: (ctx) => ConfirmDeleteDialog(
            titleDialog: 'حذف السجل',
            contentDialog: 'هل أنت متأكد من رغبتك في حذف هذا السجل؟',
            onPressedButton: () {
              confirm = true;
              ctx.pop();
            },
          ),
        );
        return confirm;
      },
      onDismissed: (direction) {
        context.read<RestAllowancesBloc>().add(DeleteExtraWorkEvent(extrawork.id));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSpacing.md),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: AppRadii.lg,
          border: Border.all(
            color: context.colorScheme.outline.withOpacity(0.15), 
            width: 1,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: cardColor),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BlocBuilder<HolidaysCubit, HolidaysState>(
                          builder: (context, holidayState) {
                            Holiday? associatedHoliday;
                            if (extrawork.holidayId != null && holidayState is HolidaysLoaded) {
                              try {
                                associatedHoliday = holidayState.financialYearHolidays.firstWhere(
                                  (h) => h.id == extrawork.holidayId,
                                );
                              } catch (_) {
                                associatedHoliday = null;
                              }
                            }
                            String pillText = '';
                            String subtitleText = '';

                            final workDateShort = extrawork.workStartDate.toDateRangeString(extrawork.workEndDate, short: true);
                            final workDateFull = extrawork.workStartDate.toDateRangeString(extrawork.workEndDate, short: false);
                            
                            if (extrawork.isUsed) {
                              final restStart = extrawork.restStartDate ?? extrawork.workStartDate;
                              final restEnd = extrawork.restEndDate ?? extrawork.workEndDate;
                              final restDateShort = restStart.toDateRangeString(restEnd, short: true);

                              pillText = '$restDateShort بدل راحه عن $workDateShort';

                              if (extrawork.workReason == WorkReason.holiday) {
                                if (associatedHoliday != null) {
                                  final holidayDateFull = associatedHoliday.startDate.toDateRangeString(associatedHoliday.endDate, short: false);
                                  subtitleText = '${associatedHoliday.name} $holidayDateFull';
                                } else {
                                  subtitleText = 'عمل رسمي في عطلة $workDateFull';
                                }
                              } else {
                                subtitleText = 'عمل إضافي (Overtime)';
                              }
                            } else {
                              if (extrawork.workReason == WorkReason.holiday) {
                                if (associatedHoliday != null) {
                                  pillText = 'رصيد عطلة (${associatedHoliday.name})';
                                } else {
                                  pillText = 'رصيد عطلة رسمية';
                                }
                              } else {
                                pillText = 'رصيد عمل إضافي';
                              }
                              subtitleText = workDateFull;
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                                  decoration: BoxDecoration(
                                    color: cardColor.withOpacity(0.08), 
                                    borderRadius: AppRadii.xl,
                                  ),
                                  child: Text(
                                    pillText,
                                    style: context.textTheme.labelMedium?.copyWith(
                                      color: cardColor,
                                    ),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded, size: 16, color: context.colorScheme.onSurfaceVariant),
                                    SizedBox(width: AppSpacing.xs),
                                    Expanded(
                                      child: Text(
                                        subtitleText,
                                        style: context.textTheme.titleMedium?.copyWith(
                                          color: context.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.06), 
                          borderRadius: AppRadii.md,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${extrawork.daysCount}', 
                              style: context.textTheme.headlineMedium?.copyWith(
                                color: cardColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              'أيام', 
                              style: context.textTheme.labelSmall?.copyWith(
                                color: cardColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}