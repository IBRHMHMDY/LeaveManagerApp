// lib/features/settings/presentation/widgets/theme_selection_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';

class ThemeSelectionSection extends StatelessWidget {
  const ThemeSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اعدادات النظام والتفضيلات',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(color: context.colorScheme.outline.withOpacity(0.15)),
          ),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isCurrentDark = themeMode == ThemeMode.dark; 
              
              return SwitchListTile(
                title: Text(
                  'الوضع الليلى',
                  style: context.textTheme.titleMedium,
                ),
                subtitle: Text(
                  isCurrentDark 
                      ? 'تفعيل المظهر الداكن للراحه البصريه' 
                      : 'تفعيل المظهر الفاتح لسطوع اوضح',
                  style: context.textTheme.bodySmall,
                ),
                secondary: Icon(
                  isCurrentDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: context.colorScheme.primary,
                ),
                value: isCurrentDark,
                onChanged: (bool value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}