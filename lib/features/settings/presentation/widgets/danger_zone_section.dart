// lib/features/settings/presentation/widgets/danger_zone_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/settings/presentation/widgets/show_about_developer.dart';
import 'package:leave_manager/shared/widgets/buttons/app_outlined_button.dart';
import 'package:leave_manager/shared/widgets/buttons/app_text_button.dart';
import 'package:leave_manager/shared/widgets/overlays/app_confirm_dialog.dart';
import 'package:leave_manager/shared/widgets/overlays/app_toast.dart';

class DangerZoneSection extends StatelessWidget {
  const DangerZoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(),
        const SizedBox(height: AppSpacing.md),
        AppOutlinedButton(
          foregroundColor: context.colorScheme.error,
          icon: Icons.delete_forever,
          label:'حذف جميع السجلات',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AppConfirmDialog(
                  title: 'تأكيد الحذف',
                  content:
                      'هل أنت متأكد من رغبتك في حذف جميع سجلات الإجازات؟ هذا الإجراء لا يمكن التراجع عنه.',
                  onConfirm: () {
                    context.read<LeavesBloc>().add(ResetAllLeavesEvent());
                    dialogContext.pop();
                    AppToast.showSuccess(context, 'تم تصفير الأرصدة وحذف السجلات');
                  },
                  confirmText: 'حذف',
                );
              },
            );
          }
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextButton(
          foregroundColor: context.colorScheme.onSurfaceVariant, 
          icon: Icons.info_outline_rounded,
          label: 'عن المطور',
          onPressed: () => showAboutDeveloperBottomSheet(context),
        ),
      ],
    );
  }
}