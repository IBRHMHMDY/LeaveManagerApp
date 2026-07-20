import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BalancesLoadingShimmer extends StatelessWidget {
  const BalancesLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Row(
      children: [
        Expanded(child: _buildShimmerCard(baseColor, highlightColor)),
        const SizedBox(width: 16),
        Expanded(child: _buildShimmerCard(baseColor, highlightColor)),
      ],
    );
  }

  Widget _buildShimmerCard(Color baseColor, Color highlightColor) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const SizedBox(
          height: 200, // ارتفاع مقارب للبطاقة الأصلية
          width: double.infinity,
        ),
      ),
    );
  }
}