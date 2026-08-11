// lib/features/settings/presentation/widgets/show_about_developer.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_colors.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/settings/presentation/cubit/app_version_cubit.dart';
import 'package:leave_manager/features/settings/presentation/cubit/app_version_state.dart';
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

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ibrhmhmdy@example.com', 
      queryParameters: {
        'subject': 'تطبيق متتبع الإجازات - تواصل',
      },
    );
    if (!await launchUrl(emailLaunchUri)) {
      debugPrint('لا يمكن فتح البريد الإلكتروني');
    }
  }

  Future<void> _launchWhatsApp() async {
    const String phoneNumber = '2001007576297'; 
    final String message = Uri.encodeComponent('مرحباً، لدي استفسار بخصوص تطبيق مدير اجازاتى.');
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber?text=$message');

    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      debugPrint('لا يمكن فتح الواتساب');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
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
          Text(
            'مدير اجازاتى',
            style: context.textTheme.headlineLarge,
          ),
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
          const SizedBox(height: AppSpacing.xl),

          // 4. بطاقة معلومات المطور
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerHighest.withOpacity(0.4),
              borderRadius: AppRadius.lg,
              border: Border.all(color: context.colorScheme.outline.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Text(
                  'تم التطوير بكل حب لخدمة الموظفين وتنظيم أوقاتهم بطريقة احترافية وذكية.',
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'تطوير وتصميم',
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'IbrahimHamdy',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // 5. زر التواصل عبر واتساب
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: AppColors.whatsappColor,
              foregroundColor: context.colorScheme.onSurface,
            ),
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            label: const Text('تواصل عبر واتساب'),
            onPressed: _launchWhatsApp,
          ),
          const SizedBox(height: AppSpacing.sm),

          // 6. زر التواصل عبر البريد
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            icon: const Icon(Icons.mail_outline_rounded),
            label: const Text('إرسال بريد إلكتروني'),
            onPressed: _launchEmail,
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // 7. حقوق الملكية
          Text(
            '© ${DateTime.now().year} جميع الحقوق محفوظة',
            style: context.textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}