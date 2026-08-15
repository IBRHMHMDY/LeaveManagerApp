// lib/features/leaves/presentation/widgets/custom_leave_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class LeaveCard extends StatelessWidget {
  final LeaveRecord leave;
  const LeaveCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final isRegular = leave.leaveType == LeaveType.regular;
    final color = isRegular ? context.leaveColors.regular : context.leaveColors.casual;

    return Dismissible(
      key: ValueKey(leave.id),
      direction: DismissDirection.endToStart,
      background: const _DismissibleBackground(),
      confirmDismiss: (direction) => _showConfirmDeleteDialog(context),
      onDismissed: (direction) {
        context.read<LeavesBloc>().add(DeleteLeaveEvent(leave.id));
      },
      child: _LeaveCardContent(
        leave: leave,
        color: color,
        isRegular: isRegular,
      ),
    );
  }

  Future<bool?> _showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: 'حذف الإجازة',
        content: 'هل أنت متأكد من رغبتك في حذف سجل الإجازة هذا؟ سيتم إعادة رصيد الأيام تلقائياً.',
        onConfirm: () => ctx.pop(true),
        confirmText: 'حذف ',
        cancelText: 'تراجع',
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
      child: Icon(Icons.delete_sweep_rounded, color: context.colorScheme.onError, size: 28),
    );
  }
}

class _LeaveCardContent extends StatelessWidget {
  final LeaveRecord leave;
  final Color color;
  final bool isRegular;

  const _LeaveCardContent({
    required this.leave,
    required this.color,
    required this.isRegular,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      indicatorColor: color,
      child: Row(
        children: [
          Expanded(
            child: _LeaveDetails(
              leave: leave,
              color: color,
              isRegular: isRegular,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          AppNumberBox(
            number: leave.daysCount,
            label: 'يوم',
            color: color,
          ),
        ],
      ),
    );
  }
}

class _LeaveDetails extends StatelessWidget {
  final LeaveRecord leave;
  final Color color;
  final bool isRegular;

  const _LeaveDetails({
    required this.leave,
    required this.color,
    required this.isRegular,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: AppRadius.xl,
          ),
          child: Text(
            isRegular ? 'إجازة اعتيادية' : 'إجازة عارضة',
            style: context.textTheme.labelMedium?.copyWith(color: color),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: context.colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                leave.startDate.isAtSameMomentAs(leave.endDate)
                    ? leave.startDate.toFormatCurrentLocale()
                    : '${leave.startDate.toFormatCurrentLocale()}  -  ${leave.endDate.toFormatCurrentLocale()}',
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        if (leave.notes != null && leave.notes!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: AppRadius.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notes_rounded, size: 14, color: context.colorScheme.onSurfaceVariant),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '${leave.notes}',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
