// lib/features/home/presentation/widgets/balances_loading_shimmer.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:shimmer/shimmer.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

class BalancesLoadingShimmer extends StatelessWidget {
  const BalancesLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildShimmerCard(context)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildShimmerCard(context)),
      ],
    );
  }

  Widget _buildShimmerCard(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceContainerHighest,
      highlightColor: context.colorScheme.surface,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xl),
        child: const SizedBox(
          height: 200,
          width: double.infinity,
        ),
      ),
    );
  }
}