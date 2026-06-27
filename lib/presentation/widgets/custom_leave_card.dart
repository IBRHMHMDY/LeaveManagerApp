import 'package:flutter/material.dart';
import '../../domain/entities/leave_record.dart'; // مسار كلاس LeaveRecord
import '../../domain/entities/leave_type.dart';     // مسار Enum الخاص بـ LeaveType
import '../../core/constants/app_colors.dart';      // مسار الألوان
import '../../core/utils/date_extension.dart';      // مسار إضافة تهيئة التاريخ

class CustomLeaveCard extends StatelessWidget {
  final LeaveRecord leave;

  const CustomLeaveCard({
    super.key,
    required this.leave,
  });

  @override
  Widget build(BuildContext context) {
    final isRegular = leave.leaveType == LeaveType.regular;
    final color = isRegular ? AppColors.regularLeaveColor : AppColors.casualLeaveColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // ظلال احترافية متعددة الطبقات تعطي عمقاً ناعماً دون تلوث بصري
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8), 
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: color.withAlpha(12), // وهج لوني خفيف جداً متناسق مع نوع الإجازة
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
        // شريط جانبي أيمن مميز يتناسب مع الواجهات العربية RTL
        border: Border(
          right: BorderSide(color: color, width: 5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // محتوى تفاصيل الإجازة (اليمين والوسط)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // شارة (Chip) نوع الإجازة
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withAlpha(20), // خلفية شفافة ناعمة من نفس اللون
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
                  
                  // نطاق التاريخ مع أيقونة عصرية
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 15, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Text(
                        '${leave.startDate.toFormattedDate()}  ←  ${leave.endDate.toFormattedDate()}',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  // صندوق الملاحظات المحسن (في حال وجودها)
                  if (leave.notes != null && leave.notes!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50, // خلفية رمادية هادئة للملاحظات
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.chat_bubble_outline_rounded, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${leave.notes}',
                              style: TextStyle(
                                color: Colors.grey.shade600,
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
            
            // عدّاد الأيام الجانبي (اليسار)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
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
                      color: Colors.grey.shade500,
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
    );
  }
}