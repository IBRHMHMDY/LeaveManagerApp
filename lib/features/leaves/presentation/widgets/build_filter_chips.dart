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
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(16),
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withAlpha(40),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getFilterIcon(filter),
                      size: 16,
                      color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      filter.label,
                      style: TextStyle(
                        fontSize: 13,
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