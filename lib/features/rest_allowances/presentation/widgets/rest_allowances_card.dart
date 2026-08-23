// lib/features/rest_allowances/presentation/widgets/rest_allowances_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/enums/work_reason.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/rest_allowances/domain/entities/extra_work_record_entity.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/consume_rest_bottomsheet.dart';

class RestAllowancesCard extends StatelessWidget {
  final ExtraWorkRecord extrawork;

  const RestAllowancesCard({super.key, required this.extrawork});

  @override
  Widget build(BuildContext context) {
    final bool isUsed = extrawork.isUsed;
    final cardColor = isUsed
        ? context.leaveColors.usedRest
        : context.leaveColors.rest;

    return Dismissible(
      key: ValueKey('extrawork_${extrawork.id}'),
      direction: DismissDirection.endToStart,
      background: const _DismissibleBackground(),
      confirmDismiss: (direction) => _showConfirmDeleteDialog(context),
      onDismissed: (direction) {
        context.read<RestAllowancesBloc>().add(
          DeleteExtraWorkEvent(extrawork.id),
        );
      },
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        indicatorColor: cardColor,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutBack,
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CardHeader(extrawork: extrawork, cardColor: cardColor),
              const SizedBox(height: AppSpacing.sm),
              _CardDates(extrawork: extrawork),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: !extrawork.isUsed
                    ? Column(
                        key: const ValueKey('actions_state'),
                        children: [
                          const Divider(height: AppSpacing.xl),
                          _CardActions(
                            extrawork: extrawork,
                            cardColor: cardColor,
                          ),
                        ],
                      )
                    : (extrawork.notes != null && extrawork.notes!.isNotEmpty)
                    ? Column(
                        key: const ValueKey('notes_state'),
                        children: [
                          const SizedBox(height: AppSpacing.sm),
                          _CardNotes(notes: extrawork.notes!),
                        ],
                      )
                    : const SizedBox.shrink(key: ValueKey('empty_state')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: 'حذف السجل',
        content: 'هل أنت متأكد من حذف هذا السجل نهائياً؟',
        onConfirm: () => ctx.pop(true),
        confirmText: 'حذف',
        cancelText: 'إلغاء',
      ),
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.error,
        borderRadius: AppRadius.lg,
      ),
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Icon(
        Icons.delete_sweep_rounded,
        color: context.colorScheme.onError,
        size: 28,
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final ExtraWorkRecord extrawork;
  final Color cardColor;
  const _CardHeader({required this.extrawork, required this.cardColor});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BlocBuilder<HolidaysCubit, HolidaysState>(
            builder: (context, holidayState) {
              String pillText = extrawork.workReason == WorkReason.holiday
                  ? 'عطلة رسمية'
                  : 'عمل إضافي';
              if (extrawork.workReason == WorkReason.holiday &&
                  holidayState is HolidaysLoaded) {
                final associatedHoliday = holidayState.financialYearHolidays
                    .where((h) => h.id == extrawork.holidayId)
                    .firstOrNull;
                if (associatedHoliday != null) {
                  pillText = 'عطلة: ${associatedHoliday.name}';
                }
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: AppBadge(
                      key: ValueKey('badge_${extrawork.isUsed}'),
                      title: extrawork.isUsed ? 'رصيد مستهلك' : 'رصيد متاح',
                      backgroundColor: extrawork.isUsed
                          ? context.colorScheme.surfaceContainerHighest
                          : cardColor.withOpacity(0.1),
                      textColor: extrawork.isUsed
                          ? context.colorScheme.onSurfaceVariant
                          : cardColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    pillText,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        AppNumberBox(
          number: extrawork.daysCount,
          label: 'أيام',
          color: cardColor,
        ),
      ],
    );
  }
}

class _CardDates extends StatelessWidget {
  final ExtraWorkRecord extrawork;
  const _CardDates({required this.extrawork});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateRow(
          icon: Icons.work_history_rounded,
          label: 'تاريخ العمل:',
          dateText: extrawork.workStartDate.toDateRangeString(
            extrawork.workEndDate,
            short: false,
          ),
        ),
        if (extrawork.isUsed && extrawork.restStartDate != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _DateRow(
            icon: Icons.event_available_rounded,
            label: 'تاريخ الاستهلاك:',
            dateText: extrawork.restStartDate!.toDateRangeString(
              extrawork.restEndDate!,
              short: false,
            ),
            iconColor: context.colorScheme.primary,
          ),
        ],
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String dateText;
  final Color? iconColor;
  const _DateRow({
    required this.icon,
    required this.label,
    required this.dateText,
    this.iconColor,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: iconColor ?? context.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$label ',
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            dateText,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardNotes extends StatelessWidget {
  final String notes;
  const _CardNotes({required this.notes});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: AppRadius.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.notes_rounded,
            size: 14,
            color: context.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              notes,
              style: context.textTheme.labelMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  final ExtraWorkRecord extrawork;
  final Color cardColor;
  const _CardActions({required this.extrawork, required this.cardColor});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppTextButton(
          onPressed: () => showConsumeRestBottomSheet(context, extrawork),
          label: 'استهلاك رصيد',
          icon: Icons.remove_circle_outline,
          foregroundColor: cardColor,
        ),
      ],
    );
  }
}
