import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';

class ThemeSelectionSection extends StatelessWidget {
  const ThemeSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCurrentDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إعدادات النظام والتفضيلات',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(50),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outline.withAlpha(40)),
          ),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return SwitchListTile(
                title: const Text(
                  'الوضع الليلي',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  isCurrentDark 
                      ? 'تفعيل المظهر الداكن للراحة البصرية' 
                      : 'تفعيل المظهر الفاتح لسطوع أوضح',
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withAlpha(140)),
                ),
                secondary: Icon(
                  isCurrentDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: colorScheme.primary,
                ),
                value: isCurrentDark,
                activeThumbColor: colorScheme.primary,
                onChanged: (bool value) {
                  context.read<ThemeCubit>().toggleTheme(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}