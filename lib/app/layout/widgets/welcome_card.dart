import 'package:flutter/material.dart';

/// ويدجت بطاقة الترحيب بالموظف
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
    // استدعاء الثيم المخصص من طبقة shared
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // القسم الأيمن (الاسم والمسمى الوظيفي)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مرحباً، $employeeName',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              // وسم المسمى الوظيفي (Badge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer, // لون حاوية أولي من الثيم
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.5), // لون الإطار من الثيم
                    width: 0.5,
                  ),
                ),
                child: Text(
                  role,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // القسم الأيسر (أيقونة المستخدم)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: colorScheme.onPrimary, // لون النص/الأيقونة فوق اللون الأساسي
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}