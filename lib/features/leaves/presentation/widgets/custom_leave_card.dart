// lib/features/leaves/presentation/widgets/custom_leave_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 1. استيراد ScreenUtil
import 'package:go_router/go_router.dart';
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
      background: const _DismissibleBackground(), 
      confirmDismiss: (direction) => _showConfirmDeleteDialog(context),
      onDismissed: (direction) {
        context.read<LeavesBloc>().add(DeleteLeaveEvent(leave.id));
      },
      child: _LeaveCardContent(
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
        onPressedButton: () => ctx.pop(true),
      ),
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h), // متجاوب (إزالة const)
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(16.r), // متجاوب
        boxShadow: [
          BoxShadow(
            color: Colors.red.withAlpha(40),
            blurRadius: 8.r, // متجاوب
            offset: Offset(0, 4.h), // متجاوب
          )
        ],
      ),
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.symmetric(horizontal: 24.w), // متجاوب
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28.w), // متجاوب
          SizedBox(height: 4.h), // متجاوب
          Text(
            'حذف', 
            style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold), // متجاوب
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
      margin: EdgeInsets.only(bottom: 14.h), // متجاوب
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r), // متجاوب
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(60) : colorScheme.shadow.withAlpha(15),
            blurRadius: 10.r, // متجاوب
            offset: Offset(0, 4.h), // متجاوب
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.transparent,
          width: 1.w, // متجاوب
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6.w, color: color), // متجاوب
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w), // متجاوب
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
                    SizedBox(width: 16.w), // متجاوب
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
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h), // متجاوب
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(20.r), // متجاوب
          ),
          child: Text(
            isRegular ? 'اعتيادية' : 'عارضة',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12.sp), // متجاوب
          ),
        ),
        SizedBox(height: 12.h), // متجاوب
        Row(
          children: [
            Icon(Icons.calendar_today_rounded, size: 16.w, color: colorScheme.onSurfaceVariant), // متجاوب
            SizedBox(width: 8.w), // متجاوب
            Expanded(
              child: Text(
                leave.startDate.isAtSameMomentAs(leave.endDate) 
                    ? leave.startDate.toFormattedDate() 
                    : '${leave.startDate.toFormattedDate()}  إلى  ${leave.endDate.toFormattedDate()}',
                style: TextStyle(
                  fontSize: 13.5.sp, // متجاوب
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (leave.notes != null && leave.notes!.isNotEmpty) ...[
          SizedBox(height: 10.h), // متجاوب
          Container(
            padding: EdgeInsets.all(10.w), // متجاوب
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(10.r), // متجاوب
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.notes_rounded, size: 14.w, color: colorScheme.onSurfaceVariant), // متجاوب
                SizedBox(width: 6.w), // متجاوب
                Expanded(
                  child: Text(
                    '${leave.notes}',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12.sp, // متجاوب
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h), // متجاوب
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(16.r), // متجاوب
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$daysCount',
            style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 24.sp, height: 1.1), // متجاوب
          ),
          Text(
            'أيام',
            style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.bold), // متجاوب
          ),
        ],
      ),
    );
  }
}