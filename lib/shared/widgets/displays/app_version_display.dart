// lib/shared/widgets/displays/app_version_display.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppVersionDisplay extends StatelessWidget {
  final String version;
  final bool isLoading;

  const AppVersionDisplay({
    super.key,
    required this.version,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.colorScheme.primary,
        ),
      );
    }
    
    return Text(
      'الإصدار: $version',
      style: context.textTheme.labelLarge?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}