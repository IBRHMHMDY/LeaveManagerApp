// lib/app/layout/widgets/main_appbar.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // تم حذف backgroundColor و elevation لأنها موروثة تلقائياً من AppTheme
    return AppBar(
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'مدير إجازاتي',
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}