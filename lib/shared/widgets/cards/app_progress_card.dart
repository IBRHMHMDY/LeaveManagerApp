// lib/shared/widgets/cards/app_progress_card.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

/// بطاقة شريط التقدم العامة لعرض الإحصائيات أو الأرصدة
/// مصممة لتكون قابلة لإعادة الاستخدام مع دعم الوضعين الفاتح والمظلم
class AppProgressCard extends StatelessWidget {
  final String title;
  final int currentValue;
  final int maxValue;
  final Color progressColor;
  final VoidCallback? onTap;

  const AppProgressCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.maxValue,
    required this.progressColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // حساب نسبة التقدم بأمان لتجنب القسمة على صفر (حسب معايير 2026 للحماية من الأعطال)
    final double progress = maxValue > 0 ? (currentValue / maxValue).clamp(0.0, 1.0) : 0.0;
    final isDark = context.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.xl,
      child: Card(
        elevation: isDark ? 0 : 4,
        shadowColor: isDark ? Colors.transparent : context.colorScheme.shadow.withOpacity(0.08),
        color: context.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: progressColor.withOpacity(isDark ? 0.4 : 1.0),
            width: 1.5,
          ),
          borderRadius: AppRadius.xl,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  // استخدام Row لضمان الترتيب (الإجمالي / الرصيد) في اللغات من اليمين لليسار
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$maxValue', // الإجمالي
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        ' / ',
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '$currentValue', // الرصيد الحالي
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: progressColor, // تمييز الرصيد الحالي بلون الشريط
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12, // سمك شريط التقدم
                  backgroundColor: progressColor.withAlpha(60),
                  valueColor: AlwaysStoppedAnimation(progressColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}