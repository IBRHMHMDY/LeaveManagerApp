import 'package:flutter/material.dart';

class CustomEmptyState extends StatelessWidget {
  final String titleEmpty;
  final String contentEmpty;
  const CustomEmptyState({super.key, required this.titleEmpty, required this.contentEmpty});

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
            color: colorScheme.onSurface.withAlpha(50),
          ),

          const SizedBox(height: 24),
          Text(
            titleEmpty,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface.withAlpha(150),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contentEmpty,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }
}
