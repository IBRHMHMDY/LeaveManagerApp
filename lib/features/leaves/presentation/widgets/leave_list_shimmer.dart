// lib/features/leaves/presentation/widgets/leave_list_shimmer.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:shimmer/shimmer.dart';

class LeaveListShimmer extends StatelessWidget {
  const LeaveListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: context.colorScheme.surfaceContainerHighest,
          highlightColor: context.colorScheme.surface,
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            height: 100, // ارتفاع متوافق مع البطاقة القياسية
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: AppRadius.lg, 
            ),
          ),
        );
      },
    );
  }
}