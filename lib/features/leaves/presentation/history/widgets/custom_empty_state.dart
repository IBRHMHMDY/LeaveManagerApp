import 'package:flutter/material.dart';

class CustomEmptyState extends StatelessWidget {
  const CustomEmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.event_busy_outlined,
          size: 80,
          color: colorScheme.onSurface.withAlpha(50), // بدلاً من grey.shade300
        ),
        const SizedBox(height: 16),
        Text(
          'لا توجد إجازات مسجلة في هذا التصنيف.',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withAlpha(150), // بدلاً من grey.shade600
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
  }
}