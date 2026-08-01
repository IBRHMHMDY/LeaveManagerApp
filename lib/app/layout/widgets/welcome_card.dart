// lib/app/layout/widgets/welcome_card.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

/// البطاقة الترحيبية للموظف، تم تحديثها لتعمل بمعايير 2026.
/// لا يوجد استخدام مباشر لـ withOpacity لتقليل استهلاك الـ GPU Rendering.
class WelcomeCard extends StatelessWidget {
  final String employeeName;
  final String role;

  const WelcomeCard({
    super.key,
    required this.employeeName,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      // استخدام ثوابت المسافات (AppSpacing) بدلاً من الأرقام الثابتة
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md, 
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // القسم الخاص بالاسم والمسمى الوظيفي
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً، $employeeName',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                  // استخدام overflow لضمان عدم حدوث خطأ إذا كان الاسم طويلاً جداً
                  overflow: TextOverflow.ellipsis, 
                ),
                SizedBox(height: AppSpacing.sm),
                // الشارة (Badge) الخاصة بالوظيفة
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, 
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    // استخدام الألوان الدلالية للأسطح الثانوية (surfaceContainer)
                    color: colorScheme.surfaceContainerHighest, 
                    borderRadius: AppRadii.xl,
                    border: Border.all(
                      color: colorScheme.outlineVariant, 
                      width: 1,
                    ),
                  ),
                  child: Text(
                    role,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          // القسم الخاص بالأيقونة الشخصية
          Container(
            width: 64, // مقاس الأيقونة ثابت لضمان التناسق
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              // استخدام انحناء متناسق مع باقي مكونات التطبيق
              borderRadius: AppRadii.lg, 
              boxShadow: [
                BoxShadow(
                  // استخدام لون الظل من المظهر ليكون متوافقاً مع الوضعين الفاتح والداكن
                  color: colorScheme.shadow.withAlpha(20), 
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: colorScheme.onPrimary, 
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}