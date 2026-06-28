// lib/core/widgets/theme_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../themes/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // نتحقق من السطوع الحالي لنرسم الأيقونة المعاكسة
        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return IconButton(
          tooltip: isDark ? 'تفعيل الوضع النهاري' : 'تفعيل الوضع الليلي',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            // استدعاء دالة التبديل من الـ Cubit
            context.read<ThemeCubit>().toggleTheme(context);
          },
        );
      },
    );
  }
}