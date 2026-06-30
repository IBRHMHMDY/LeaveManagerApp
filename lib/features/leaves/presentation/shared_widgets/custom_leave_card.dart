// lib/features/leaves/presentation/shared_widgets/custom_leave_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/leave_record_entity.dart';
import '../../../../core/utils/enums/leave_type.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/extenstions/date_extension.dart';
import '../blocs/leaves_bloc.dart'; // استدعاء الـ BLoC لإطلاق الحدث

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
      // 1. يجب إعطاء مفتاح فريد لكل كارت لكي لا يحدث تداخل عند إعادة بناء القائمة
      key: ValueKey(leave.id),
      
      // 2. اتجاه السحب (من البداية للنهاية - أي من اليمين لليسار في الواجهة العربية)
      direction: DismissDirection.endToStart,
      
      // 3. الخلفية التي تظهر خلف الكارت أثناء السحب
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: AlignmentDirectional.centerEnd, // محاذاة الأيقونة لليمين
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 32),
      ),
      
      // 4. دالة تأكيد الحذف (تمنع اختفاء الكارت إذا تراجع المستخدم)
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('تأكيد الحذف'),
            content: const Text('هل أنت متأكد من رغبتك في حذف هذه الإجازة واسترداد أيامها لرصيدك؟'),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('إلغاء', style: TextStyle(color: colorScheme.onSurface)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('نعم، حذف'),
              ),
            ],
          ),
        );
      },
      
      // 5. الإجراء الفعلي الذي يحدث بعد اختفاء الكارت
      onDismissed: (direction) {
        context.read<LeavesBloc>().add(DeleteLeaveEvent(leave.id));
      },
      
      // 6. الكارت الأصلي الخاص بك (بدون زر الـ IconButton الذي أضفناه سابقاً)
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        clipBehavior: Clip.antiAlias, 
        decoration: BoxDecoration(
          color: colorScheme.surface, 
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.transparent : Colors.black.withAlpha(8), 
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.transparent,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              start: 0, 
              top: 0,
              bottom: 0,
              child: Container(
                width: 5,
                color: color,
              ),
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
                            color: color.withAlpha(20),
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
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        if (leave.notes != null && leave.notes!.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black26 : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(10),
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
                      color: isDark ? Colors.black26 : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
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