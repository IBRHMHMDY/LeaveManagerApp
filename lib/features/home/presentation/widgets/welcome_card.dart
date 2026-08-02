// lib/app/layout/widgets/welcome_card.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/widgets/custom_badge.dart';

/// البطاقة الترحيبية للموظف، تم تحديثها لتعمل بمعايير 2026.
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md, 
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحبا، $employeeName',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: context.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis, 
                ),
                SizedBox(height: AppSpacing.sm),
                CustomBadge(titleBadge: role)
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Container(
            width: 64, 
            height: 64,
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: AppRadii.lg, 
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withOpacity(0.08), // بديل withAlpha(20)
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: context.colorScheme.onPrimary, 
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}