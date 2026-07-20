// lib/features/home/presentation/widgets/balances_loading_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(width: 16.w), // مسافة عرضية متجاوبة
        Expanded(child: _buildShimmerCard(baseColor, highlightColor)),
      ],
    );
  }

  Widget _buildShimmerCard(Color baseColor, Color highlightColor) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Card(
        // توافق مع الزوايا في المكون الحقيقي
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: SizedBox(
          height: 200.h, // ارتفاع متجاوب مقارب للبطاقة الأصلية
          width: double.infinity,
        ),
      ),
    );
  }
}