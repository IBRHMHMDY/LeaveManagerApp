// lib/features/settings/presentation/widgets/theme_selection_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/shared/themes/theme_cubit.dart';

class ThemeSelectionSection extends StatelessWidget {
  const ThemeSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المظهر',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(50),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colorScheme.outline.withAlpha(40)),
          ),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isCurrentDark = themeMode == ThemeMode.dark; // الاعتماد على الـ State
              
              return SwitchListTile(
                title: Text(
                  'الوضع الداكن',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  isCurrentDark 
                      ? 'مفعل حالياً' 
                      : 'غير مفعل',
                  style: TextStyle(fontSize: 12.sp, color: colorScheme.onSurface.withAlpha(140)),
                ),
                secondary: Icon(
                  isCurrentDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: colorScheme.primary,
                ),
                value: isCurrentDark,
                activeThumbColor: colorScheme.primary,
                onChanged: (bool value) {
                  // استدعاء الدالة النظيفة
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