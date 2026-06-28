// lib/core/widgets/custom_leave_card.dart
import 'package:flutter/material.dart';
import '../../features/leaves/domain/entities/leave_record_entity.dart';
import '../utils/enums/leave_type.dart';
import '../constants/app_colors.dart';
import '../utils/extenstions/date_extension.dart';

class CustomLeaveCard extends StatelessWidget {
  final LeaveRecord leave;

  const CustomLeaveCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final isRegular = leave.leaveType == LeaveType.regular;
    final color = isRegular ? AppColors.regularLeaveColor : AppColors.casualLeaveColor;
    
    // استدعاء ألوان الثيم الحالي
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      // تفعيل القص التلقائي لضمان عدم خروج الشريط الملون عن الحواف الدائرية
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
        // 1. توحيد الإطار الخارجي ليتوافق مع الـ borderRadius
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.transparent,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // 2. رسم الشريط الملون الجانبي باستخدام PositionedDirectional لدعم الـ RTL (من اليمين لليسار)
          PositionedDirectional(
            start: 0, // يبدأ من اليمين في واجهة اللغة العربية
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              color: color,
            ),
          ),
          
          // 3. محتوى البطاقة الفعلي
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
    );
  }
}