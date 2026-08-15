// lib/shared/widgets/displays/app_number_box.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

class AppNumberBox extends StatelessWidget {
  final int number;
  final String label;
  final Color color;

  const AppNumberBox({
    super.key,
    required this.number,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: AppRadius.lg,
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$number',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 24,
              height: 1.1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}