// lib/features/backup_restore/presentation/widgets/backup_settings_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/backup_restore/presentation/cubit/backup_cubit.dart';
import 'package:leave_manager/features/backup_restore/presentation/cubit/backup_state.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class BackupSettingsSection extends StatelessWidget {
  const BackupSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BackupCubit>()..checkAuthStatus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'النسخ الاحتياطي والمزامنة',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          BlocConsumer<BackupCubit, BackupState>(
            listener: (context, state) {
              if (state is BackupError) {
                AppToast.showError(context, state.message);
              } else if (state is BackupSuccess) {
                AppToast.showSuccess(context, state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is BackupLoading;
              final authState = state is BackupAuthStatus ? state : null;
              final isSignedIn = authState?.isSignedIn ?? false;

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
                    // --- النسخ المحلي ---
                    Text('النسخة المحلية', style: context.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: AppOutlinedButton(
                            label: 'حفظ نسخة',
                            icon: Icons.save_alt_rounded,
                            isLoading: isLoading,
                            onPressed: isLoading
                                ? null
                                : () => context
                                      .read<BackupCubit>()
                                      .createLocalBackup(),
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
                                : () => context
                                      .read<BackupCubit>()
                                      .restoreLocalBackup(),
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Divider(),
                    ),

                    // --- التخزين السحابي (Google Drive) ---
                    Text(
                      'النسخة السحابيه',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    if (!isSignedIn)
                      AppPrimaryButton(
                        label: 'تسجيل الدخول بحساب Google',
                        icon: Icons.cloud_done_rounded,
                        isLoading: isLoading,
                        onPressed: isLoading
                            ? null
                            : () => context.read<BackupCubit>().signIn(),
                      )
                    else ...[
                      Row(
                        children: [
                          Expanded(
                            child: AppOutlinedButton(
                              label: 'رفع',
                              icon: Icons.cloud_upload_rounded,
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () => context
                                        .read<BackupCubit>()
                                        .createCloudBackup(),
                              foregroundColor: context.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: AppOutlinedButton(
                              label: 'استعادة',
                              icon: Icons.cloud_download_rounded,
                              isLoading: isLoading,
                              onPressed: isLoading
                                  ? null
                                  : () => context
                                        .read<BackupCubit>()
                                        .restoreCloudBackup(),
                              foregroundColor: context.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (authState?.lastBackupMetadata != null) ...[
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: context.colorScheme.primaryContainer
                                .withOpacity(0.3),
                            borderRadius: AppRadius.sm,
                          ),
                          child: Text(
                            'آخر نسخة سحابية: ${authState!.lastBackupMetadata!.createdAt.toString().split('.')[0]}\nالحجم: ${authState.lastBackupMetadata!.sizeInMB.toStringAsFixed(2)} MB',
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Google Drive',
                            style: context.textTheme.titleMedium,
                          ),
                          if (isSignedIn)
                            TextButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () => context.read<BackupCubit>().signOut(),
                              icon: const Icon(Icons.logout, size: 18),
                              label: const Text('تسجيل خروج'),
                            ),
                        ],
                      ),
                    ],
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
