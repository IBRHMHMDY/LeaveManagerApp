// lib/features/rest_allowances/presentation/widgets/rest_allowance_tabs.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestAllowanceTabs extends StatelessWidget {
  final bool showAvailables;
  final int availablesCount;
  final int usageCount;
  final ValueChanged<bool> onChanged;

  const RestAllowanceTabs({
    super.key,
    required this.showAvailables,
    required this.availablesCount,
    required this.usageCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'اضافى/عطلات ($availablesCount)',
              isActive: showAvailables,
              onTap: () => onChanged(true),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _TabButton(
              title: 'بدلات الراحه ($usageCount)',
              isActive: !showAvailables,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({required this.title, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color restColor = const Color(0xE07C4DFF);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? restColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: isActive ?colorScheme.surface : restColor ,
          ),
        ),
      ),
    );
  }
}