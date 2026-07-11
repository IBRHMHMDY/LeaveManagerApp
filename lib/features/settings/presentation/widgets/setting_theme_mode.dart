// lib/features/settings/presentation/widgets/setting_theme_mode.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';

class SettingThemeMode extends StatelessWidget {
  const SettingThemeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        // حساب السطوع داخل الـ BlocBuilder لضمان التحديث الفوري عند التغيير
        final isCurrentDark = Theme.of(context).brightness == Brightness.dark;
        final colorScheme = Theme.of(context).colorScheme;

        return SwitchListTile(
          title: Text(
            isCurrentDark? 'الوضع الليلي': 'الوضع النهارى',
            style: TextStyle(
              fontSize: 15, 
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
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
            // استخدام اللون الأساسي من الثيم لضمان ظهوره بوضوح تام في الوضعين
            color: colorScheme.primary,
          ),
          value: isCurrentDark,
          activeThumbColor: isCurrentDark? AppColors.accentCoral : AppColors.primaryTeal,
          onChanged: (bool value) {
            context.read<ThemeCubit>().toggleTheme(context);
          },
        );
      },
    );
  }
}