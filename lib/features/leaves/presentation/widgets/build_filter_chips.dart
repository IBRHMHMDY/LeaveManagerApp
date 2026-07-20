import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد المكتبة
import 'package:leave_manager/core/utils/extenstions/leave_filter_extension.dart';

class BuildFilterChips extends StatelessWidget {
  final LeaveFilter selectedFilter;
  final ValueChanged<LeaveFilter> onFilterChanged;

  const BuildFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  IconData _getFilterIcon(LeaveFilter filter) {
    switch (filter) {
      case LeaveFilter.all:
        return Icons.all_inclusive_rounded;
      case LeaveFilter.regular:
        return Icons.event_available_rounded;
      case LeaveFilter.casual:
        return Icons.event_busy_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.all(16.w), // إزالة const واستخدام .w
      padding: EdgeInsets.all(4.w), // إزالة const واستخدام .w
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(16.r), // متجاوب
      ),
      child: Row(
        children: LeaveFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isSelected) onFilterChanged(filter);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(vertical: 12.h), // إزالة const واستخدام .h
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r), // متجاوب
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withAlpha(40),
                            blurRadius: 8.r, // متجاوب
                            offset: Offset(0, 2.h), // متجاوب
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getFilterIcon(filter),
                      size: 16.w, // حجم الأيقونة متجاوب
                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 6.w), // مسافة متجاوبة
                    Text(
                      filter.label,
                      style: TextStyle(
                        fontSize: 13.sp, // حجم الخط متجاوب
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}