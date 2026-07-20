import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/app_info_helper.dart';

class CurrentVersion extends StatelessWidget {
  const CurrentVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'الاصدار ${AppInfoHelper.getVersionOnly().toString()}',
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
