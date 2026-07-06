import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../holidays/domain/entities/holiday_entity.dart';

/// كارت عرض الإجازة الرسمية القادمة في الشاشة الرئيسية.
/// يعتمد على [Holiday] كمتغير اختياري لعرض الإجازة القادمة، 
/// ويستخدم [GoRouter] للانتقال لشاشة الإجازات.
class UpcomingHolidayCard extends StatelessWidget {
  final Holiday? nextHoliday;

  const UpcomingHolidayCard({
    super.key,
    this.nextHoliday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --- القسم الأيمن: تفاصيل الإجازة ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'الإجازات الرسمية',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8.0),
                
                // التحقق من وجود إجازة قادمة
                if (nextHoliday != null) ...[
                  Text(
                    nextHoliday!.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    // تنسيق التاريخ ليكون مقروءاً (مثال: 09 مارس 2027)
                    DateFormat('dd MMMM yyyy', 'ar').format(nextHoliday!.startDate),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ] else ...[
                  Text(
                    'لا توجد إجازات قادمة قريباً',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // --- القسم الأيسر: زر الانتقال لشاشة الإجازات ---
          const SizedBox(width: 12.0),
          Material(
            color: theme.colorScheme.primary.withAlpha(10),
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () {
                // الانتقال إلى شاشة الإجازات عبر GoRouter
                // يرجى التأكد من أن مسار الشاشة (Route name or path) مطابق لملف app_router.dart
                context.push('/holidays'); 
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                // استخدام أيقونة تتناسب مع اتجاه التطبيق (RTL)
                child: Icon(
                  Icons.arrow_back_ios_new_rounded, 
                  color: theme.colorScheme.primary,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}