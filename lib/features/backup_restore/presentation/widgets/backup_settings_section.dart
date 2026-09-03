// lib/features/backup_restore/presentation/widgets/backup_settings_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/app_restarter.dart'; // استيراد كلاس إعادة التشغيل
import 'package:leave_manager/features/backup_restore/presentation/cubit/backup_cubit.dart';
import 'package:leave_manager/features/backup_restore/presentation/cubit/backup_state.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class BackupSettingsSection extends StatelessWidget {
  const BackupSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BackupCubit>(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'النسخ الاحتياطي والاستعادة',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          BlocConsumer<BackupCubit, BackupState>(
            listener: (context, state) {
              if (state is BackupError) {
                AppToast.showError(context, state.message);
              } else if (state is BackupSuccess) {
                AppToast.showSuccess(context, state.message);
                
                // التحقق من الحاجة لإعادة التشغيل بعد نجاح الاستعادة
                if (state.requiresRestart) {
                  Future.delayed(const Duration(seconds: 2), () {
                    if (context.mounted) {
                      AppRestarter.restartApp(context);
                    }
                  });
                }
              }
            },
            builder: (context, state) {
              final isLoading = state is BackupLoading;
              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: AppRadius.lg,
                  border: Border.all(
                    color: context.colorScheme.outline.withAlpha(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('النسخه المحليه', style: context.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppOutlinedButton(
                            label: 'حفظ نسخه',
                            icon: Icons.save_alt_rounded,
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () => context.read<BackupCubit>().createLocalBackup(),
                            foregroundColor: context.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: AppOutlinedButton(
                            label: 'استعادة',
                            icon: Icons.restore_rounded,
                            isLoading: isLoading,
                            foregroundColor: context.colorScheme.error,
                            onPressed: isLoading
                                ? null
                                : () => context.read<BackupCubit>().restoreLocalBackup(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}