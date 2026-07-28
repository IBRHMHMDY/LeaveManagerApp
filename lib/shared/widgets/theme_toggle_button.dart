// lib/shared/widgets/theme_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../themes/theme_cubit.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // نعتمد على الـ themeMode القادم من الـ BLoC State
        final isDark = themeMode == ThemeMode.dark;
        
        return IconButton(
          tooltip: isDark ? 'تفعيل الوضع الفاتح' : 'تفعيل الوضع الداكن',
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () {
            // استدعاء الدالة النظيفة بدون تمرير سياق (Context)
            context.read<ThemeCubit>().toggleTheme();
          },
        );
      },
    );
  }
}