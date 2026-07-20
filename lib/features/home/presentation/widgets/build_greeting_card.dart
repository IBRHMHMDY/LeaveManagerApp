import 'package:flutter/material.dart';
import 'package:leave_manager/features/settings/domain/entities/settings_entity.dart';

class BuildGreetingCard extends StatelessWidget {
  final Settings settings;

  const BuildGreetingCard({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً، ${settings.employeeName}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          settings.jobTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}