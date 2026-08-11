// // lib/features/leaves/presentation/widgets/build_filter_chips.dart
// import 'package:flutter/material.dart';
// import 'package:leave_manager/core/constants/app_spacing.dart';
// import 'package:leave_manager/core/utils/extenstions/leave_filter_extension.dart';
// import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

// class BuildFilterChips extends StatelessWidget {
//   final LeaveFilter selectedFilter;
//   final ValueChanged<LeaveFilter> onFilterChanged;

//   const BuildFilterChips({
//     super.key,
//     required this.selectedFilter,
//     required this.onFilterChanged,
//   });

//   IconData _getFilterIcon(LeaveFilter filter) {
//     switch (filter) {
//       case LeaveFilter.all:
//         return Icons.all_inclusive_rounded;
//       case LeaveFilter.regular:
//         return Icons.event_available_rounded;
//       case LeaveFilter.casual:
//         return Icons.event_busy_rounded;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.all(AppSpacing.md),
//       padding: const EdgeInsets.all(AppSpacing.xs),
//       decoration: BoxDecoration(
//         color: context.colorScheme.surfaceContainerHighest.withOpacity(0.3),
//         borderRadius: AppRadius.lg,
//       ),
//       child: Row(
//         children: LeaveFilter.values.map((filter) {
//           final isSelected = selectedFilter == filter;
//           return Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 if (!isSelected) onFilterChanged(filter);
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
//                 decoration: BoxDecoration(
//                   color: isSelected ? context.colorScheme.primary : Colors.transparent,
//                   borderRadius: AppRadius.md,
//                   boxShadow: isSelected
//                       ? [
//                           BoxShadow(
//                             color: context.colorScheme.primary.withOpacity(0.15),
//                             blurRadius: 8,
//                             offset: const Offset(0, 2),
//                           )
//                         ]
//                       : [],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       _getFilterIcon(filter),
//                       size: 18,
//                       color: isSelected ? context.colorScheme.onPrimary : context.colorScheme.onSurfaceVariant,
//                     ),
//                     const SizedBox(width: AppSpacing.xs),
//                     Text(
//                       filter.label,
//                       style: context.textTheme.labelLarge?.copyWith(
//                         fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
//                         color: isSelected ? context.colorScheme.onPrimary : context.colorScheme.onSurfaceVariant,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }