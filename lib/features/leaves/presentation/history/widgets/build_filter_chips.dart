import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/leave_filter_extension.dart';

class BuildFilterChips extends StatelessWidget {
  final LeaveFilter selectedFilter;
  final ValueChanged<LeaveFilter> onFilterChanged;

  const BuildFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: LeaveFilter.values.map((filter) {
          final isSelected = selectedFilter == filter;
          return ChoiceChip(
            label: Text(
              filter.label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              ),
            ),
            selected: isSelected,
            selectedColor: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
            onSelected: (selected) {
              if (selected) {
                // استدعاء الدالة لتحديث الحالة في الشاشة الأب
                onFilterChanged(filter);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}