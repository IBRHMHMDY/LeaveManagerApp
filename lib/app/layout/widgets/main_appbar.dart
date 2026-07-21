import 'package:flutter/material.dart';

/// ويدجت تمثل الـ AppBar الثابت أعلى التطبيق وتتصل بثيم التطبيق المخصص
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الثيم المخصص من طبقة shared
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // القسم الأيمن (النصوص)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'دفتر إجازاتي',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface, // استخدام لون النص من الثيم
                ),
              ),
              const SizedBox(height: 8,),
              // Text(
              //   'تتبع ذكي وسلس للأرصدة',
              //   style: theme.textTheme.bodyMedium?.copyWith(
              //     color: colorScheme.onSurface.withOpacity(0.6),
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
