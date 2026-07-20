import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد المكتبة
import 'package:shimmer/shimmer.dart';

/// مكون يعرض هيكل تحميل (Skeleton) لقائمة الإجازات
class LeaveListShimmer extends StatelessWidget {
  const LeaveListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // إزالة const
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h), // إزالة const واستخدام .h
            height: 100.h, // ارتفاع متجاوب يطابق البطاقة الأصلية
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r), // متجاوب
            ),
          ),
        );
      },
    );
  }
}