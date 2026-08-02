// lib/features/home/presentation/widgets/balance_circular_indicator.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class BalanceCircularIndicator extends StatelessWidget {
  final String title;
  final int remaining;
  final int total;
  final Color color;

  const BalanceCircularIndicator({
    super.key,
    required this.title,
    required this.remaining,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = total > 0 ? (remaining / total) : 0;
    final isDark = context.isDarkMode;

    return InkWell(
      onTap: () => context.go(AppRouter.leaves),
      borderRadius: AppRadii.xl,
      child: Card(
        elevation: isDark ? 0 : 4,
        shadowColor: isDark ? Colors.transparent : context.colorScheme.shadow.withOpacity(0.08),
        color: context.colorScheme.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: color.withOpacity(isDark ? 0.4 : 1.0),
            width: 1.5,
          ),
          borderRadius: AppRadii.xl,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.md),
          child: Column(
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 10,
                      backgroundColor: color.withOpacity(0.2),
                      color: color,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$remaining',
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: color,
                        ),
                      ),
                      Text(
                        '/ $total',
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
        ),
      ),
    );
  }
}