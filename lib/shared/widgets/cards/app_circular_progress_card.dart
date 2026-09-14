// lib/shared/widgets/cards/app_circular_progress_card.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

/// بطاقة شريط التقدم الدائري العامة
/// مصممة لتكون قابلة لإعادة الاستخدام مع دعم الوضعين الفاتح والمظلم والـ RTL
class AppCircularProgressCard extends StatelessWidget {
  final String title;
  final int currentValue;
  final int maxValue;
  final Color progressColor;
  final VoidCallback? onTap;

  const AppCircularProgressCard({
    super.key,
    required this.title,
    required this.currentValue,
    required this.maxValue,
    required this.progressColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // حماية من خطأ القسمة على صفر (Division by Zero)
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
            mainAxisSize: MainAxisSize.min, // للحفاظ على الأداء ومنع التمدد غير المبرر
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: progressColor.withAlpha(60),
                      color: progressColor,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$currentValue', // الرصيد الحالي
                        style: context.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: progressColor, // تمييز الرصيد بلون الدائرة
                        ),
                      ),
                      const SizedBox(height: 4),
                      // استخدام Row لضمان الترتيب الصحيح (الرصيد /) في الـ RTL
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$maxValue', // الإجمالي
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            ' /',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}