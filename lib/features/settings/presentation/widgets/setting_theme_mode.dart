import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';

class SettingThemeMode extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isCurrentDark;
  const SettingThemeMode({super.key, required this.colorScheme,required this.isCurrentDark});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return SwitchListTile(
          title: Text(
            isCurrentDark? 'الوضع الليلي': 'الوضع النهارى',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            isCurrentDark
                ? 'تفعيل المظهر الداكن للراحة البصرية'
                : 'تفعيل المظهر الفاتح لسطوع أوضح',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(140),
            ),
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
    );
  }
}