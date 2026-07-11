// lib/features/leaves/presentation/shared_widgets/custom_leave_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leave_record_entity.dart';
import '../../../../core/utils/enums/leave_type.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extenstions/date_extension.dart';
import '../blocs/leaves_bloc.dart';

class CustomLeaveCard extends StatelessWidget {
  final LeaveRecord leave;

  const CustomLeaveCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final isRegular = leave.leaveType == LeaveType.regular;
    final color = isRegular ? AppColors.regularLeaveColor : AppColors.casualLeaveColor;
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(leave.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(20), // ليتماشى مع حواف الثيم الجديد
        ),
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 32),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد من رغبتك في حذف هذه الإجازة واسترداد أيامها لرصيدك؟'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('إلغاء', style: TextStyle(color: colorScheme.onSurface)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('نعم، حذف'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        context.read<LeavesBloc>().add(DeleteLeaveEvent(leave.id));
      },
      // استخدام Card بدلاً من Container ليرث تصميم AppTheme تلقائياً
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PositionedDirectional(
              start: 0,
              top: 0,
              bottom: 0,
              child: Container(width: 5, color: color),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isRegular ? 'إجازة اعتيادية' : 'إجازة عارضة',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 15, color: colorScheme.onSurface.withAlpha(150)),
                            const SizedBox(width: 8),
                            Text(
                              '${leave.startDate.toFormattedDate()}  ←  ${leave.endDate.toFormattedDate()}',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        if (leave.notes != null && leave.notes!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // استخدام ألوان السطح المتدرجة من الثيم
                              color: colorScheme.surfaceContainerHighest.withAlpha(100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.chat_bubble_outline_rounded, size: 14, color: colorScheme.onSurface.withAlpha(150)),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${leave.notes}',
                                    style: TextStyle(
                                      color: colorScheme.onSurface.withAlpha(200),
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
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withAlpha(15), // خلفية ناعمة من نفس لون الإجازة
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${leave.daysCount}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'أيام',
                          style: TextStyle(
                            color: colorScheme.onSurface.withAlpha(150),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}