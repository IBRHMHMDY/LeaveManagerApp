// lib/shared/widgets/theme_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import '../themes/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        return IconButton(
          tooltip: isDark ? 'تفعيل الوضع الفاتح' : 'تفعيل الوضع الداكن',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? context.colorScheme.onSurface : context.colorScheme.error,
          ),
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        );
      },
    );
  }
}