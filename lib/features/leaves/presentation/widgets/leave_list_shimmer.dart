// lib/features/leaves/presentation/widgets/leave_list_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

/// تأثير الهيكل العظمي (Skeleton) للتحميل
class LeaveListShimmer extends StatelessWidget {
  const LeaveListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: colorScheme.surfaceContainerHighest,
          highlightColor: colorScheme.surface,
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            height: 100.h,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: AppRadii.lg, // استخدام نصف القطر الموحد
            ),
          ),
        );
      },
    );
  }
}