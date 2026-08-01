// lib/features/home/presentation/widgets/balances_loading_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

class BalancesLoadingShimmer extends StatelessWidget {
  const BalancesLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: _buildShimmerCard(colorScheme)),
        SizedBox(width: AppSpacing.md),
        Expanded(child: _buildShimmerCard(colorScheme)),
      ],
    );
  }

  Widget _buildShimmerCard(ColorScheme colorScheme) {
    return Shimmer.fromColors(
      // استخدام الألوان الدلالية بدلاً من الألوان الثابتة
      baseColor: colorScheme.surfaceContainerHighest,
      highlightColor: colorScheme.surface,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.xl),
        child: SizedBox(
          height: 200.h,
          width: double.infinity,
        ),
      ),
    );
  }
}