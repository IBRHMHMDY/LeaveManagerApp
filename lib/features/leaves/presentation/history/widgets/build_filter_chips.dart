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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildChip(context, LeaveFilter.all, 'الكل'),
          const SizedBox(width: 8),
          _buildChip(context, LeaveFilter.regular, 'اعتيادي'),
          const SizedBox(width: 8),
          _buildChip(context, LeaveFilter.casual, 'عارضة'),
          // تم إزالة فلتر "بدل راحة" من هنا
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, LeaveFilter filter, String label) {
    final isSelected = selectedFilter == filter;
    final colorScheme = Theme.of(context).colorScheme;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onFilterChanged(filter),
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primary,
      checkmarkColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? colorScheme.primary : colorScheme.outline,
        ),
      ),
    );
  }
}