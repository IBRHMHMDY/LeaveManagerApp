import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // للتعامل مع context.pop
import 'package:leave_manager/features/leaves/domain/entities/leave_record_entity.dart';
import 'package:leave_manager/core/utils/enums/leave_type.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/shared/themes/app_colors.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';

class CustomLeaveCard extends StatelessWidget {
  final LeaveRecord leave;
  const CustomLeaveCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final isRegular = leave.leaveType == LeaveType.regular;
    final color = isRegular ? AppColors.regularLeaveColor : AppColors.casualLeaveColor;
    
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(leave.id),
      direction: DismissDirection.endToStart,
      background: const _DismissibleBackground(), // فصل الخلفية
      confirmDismiss: (direction) => _showConfirmDeleteDialog(context),
      onDismissed: (direction) {
        context.read<LeavesBloc>().add(DeleteLeaveEvent(leave.id));
      },
      child: _LeaveCardContent( // فصل المحتوى الرئيسي
        leave: leave,
        color: color,
        isRegular: isRegular,
        isDark: isDark,
        colorScheme: colorScheme,
      ),
    );
  }

  Future<bool?> _showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDeleteDialog(
        titleDialog: 'تأكيد الحذف',
        contentDialog: 'هل أنت متأكد من رغبتك في حذف هذه الإجازة؟',
        onPressedButton: () => ctx.pop(true), // إرجاع true لتأكيد الحذف
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// المكونات الفرعية (Private Sub-Widgets) لتحسين الأداء وسهولة القراءة
// -----------------------------------------------------------------------------

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
          SizedBox(height: 4),
          Text(
            'حذف', 
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _LeaveCardContent extends StatelessWidget {
  final LeaveRecord leave;
  final Color color;
  final bool isRegular;
  final bool isDark;
  final ColorScheme colorScheme;

  const _LeaveCardContent({
    required this.leave,
    required this.color,
    required this.isRegular,
    required this.isDark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(60) : colorScheme.shadow.withAlpha(15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.transparent,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: color),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _LeaveDetails(
                        leave: leave,
                        color: color,
                        isRegular: isRegular,
                        colorScheme: colorScheme,
                      ),
                    ),
                    const SizedBox(width: 16),
                    _LeaveDaysBox(color: color, daysCount: leave.daysCount),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaveDetails extends StatelessWidget {
  final LeaveRecord leave;
  final Color color;
  final bool isRegular;
  final ColorScheme colorScheme;

  const _LeaveDetails({
    required this.leave,
    required this.color,
    required this.isRegular,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isRegular ? 'اعتيادية' : 'عارضة',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                leave.startDate.isAtSameMomentAs(leave.endDate) 
                    ? leave.startDate.toFormattedDate() 
                    : '${leave.startDate.toFormattedDate()}  إلى  ${leave.endDate.toFormattedDate()}',
                style: TextStyle(
                  fontSize: 13.5,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (leave.notes != null && leave.notes!.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notes_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${leave.notes}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
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

class _LeaveDaysBox extends StatelessWidget {
  final Color color;
  final int daysCount;

  const _LeaveDaysBox({required this.color, required this.daysCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$daysCount',
            style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 24, height: 1.1),
          ),
          Text(
            'أيام',
            style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}