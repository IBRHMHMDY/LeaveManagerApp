// lib/features/settings/presentation/widgets/show_about_developer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/utils/AppVersions/cubit/app_version_cubit.dart';
import 'package:leave_manager/core/utils/AppVersions/cubit/app_version_state.dart';
import 'package:leave_manager/core/utils/store_launcher_service.dart';
import 'package:leave_manager/shared/widgets/buttons/app_outlined_button.dart';
import 'package:leave_manager/shared/widgets/buttons/app_primary_button.dart';
import 'package:leave_manager/shared/widgets/buttons/app_share_button.dart';
import 'package:leave_manager/shared/widgets/displays/app_version_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leave_manager/features/splash/presentation/widgets/custom_app_logo_icon.dart';

void showAboutDeveloperBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colorScheme.surface,
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (ctx) => const _AboutDeveloperContent(),
  );
}

class _AboutDeveloperContent extends StatefulWidget {
  const _AboutDeveloperContent();

  @override
  State<_AboutDeveloperContent> createState() => _AboutDeveloperContentState();
}

class _AboutDeveloperContentState extends State<_AboutDeveloperContent> {
  Future<void> _launchWhatsApp() async {
    const String phoneNumber = '2001007576297';
    final String message = Uri.encodeComponent(
      'مرحباً، لدي استفسار بخصوص تطبيق مدير اجازاتى.',
    );
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=$message',
    );

    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      debugPrint('لا يمكن فتح الواتساب');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. مؤشر السحب
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: context.colorScheme.onSurface.withOpacity(0.2),
              borderRadius: AppRadius.sm,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // 2. شعار التطبيق
          const CustomAppLogoIcon(),
          const SizedBox(height: AppSpacing.md),

          // 3. اسم التطبيق وإصداره
          Text('مدير اجازاتى', style: context.textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.sm),
          BlocProvider(
            create: (context) => AppVersionCubit()..fetchVersion(),
            child: BlocBuilder<AppVersionCubit, AppVersionState>(
              builder: (context, state) {
                if (state is AppVersionLoading) {
                  return const AppVersionDisplay(
                    version: '',
                    isLoading: true, // سيعرض مؤشر التحميل
                  );
                } else if (state is AppVersionLoaded) {
                  return AppVersionDisplay(
                    version: state.version, // سيعرض رقم الإصدار
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 4. بطاقة معلومات المطور
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest.withOpacity(
                0.4,
              ),
              borderRadius: AppRadius.lg,
              border: Border.all(
                color: context.colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        'تطوير وتصميم',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),

                      Text(
                        'IbrahimHamdy',
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppOutlinedButton(
                label: 'تقييم التطبيق',
                foregroundColor: context.colorScheme.primary,
                onPressed: () => StoreLauncherService().launchPlayStore(
                  appId: 'com.ibrahimhamdy.leavemanager',
                ),
                icon: Icons.star_rate_rounded,
              ),
              const SizedBox(height: AppSpacing.sm),
              const AppShareButton(buttonType: ShareButtonType.outline),
              const SizedBox(height: AppSpacing.sm),
              // 5. زر التواصل عبر واتساب
              AppPrimaryButton(
                backgroundColor: AppColors.whatsappBGColor,
                foregroundColor: AppColors.whatsappFGColor,
                icon: Icons.chat_bubble_outline_rounded,
                label: 'تواصل عبر واتساب',
                onPressed: _launchWhatsApp,
              ),
              const SizedBox(height: AppSpacing.lg),
              // 7. حقوق الملكية
              Center(
                child: Text(
                  '© ${DateTime.now().year} جميع الحقوق محفوظة',
                  style: context.textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ],
      ),
    );
  }
}
