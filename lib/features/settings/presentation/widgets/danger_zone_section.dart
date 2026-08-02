// lib/features/settings/presentation/widgets/danger_zone_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/settings/presentation/widgets/show_about_developer.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class DangerZoneSection extends StatelessWidget {
  const DangerZoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.md),
        const Divider(),
        SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: context.colorScheme.error, 
            side: BorderSide(color: context.colorScheme.error, width: 1.5), 
          ),
          icon: const Icon(Icons.delete_forever, size: 24),
          label: const Text('حذف جميع السجلات'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return ConfirmDeleteDialog(
                  titleDialog: 'تأكيد الحذف',
                  contentDialog:
                      'هل أنت متأكد من رغبتك في حذف جميع سجلات الإجازات؟ هذا الإجراء لا يمكن التراجع عنه.',
                  onPressedButton: () {
                    context.read<LeavesBloc>().add(ResetAllLeavesEvent());
                    dialogContext.pop();
                    AppToast.showSuccess(context, 'تم تصفير الأرصدة وحذف السجلات');
                  },
                );
              },
            );
          }
        ),
        SizedBox(height: AppSpacing.md),
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: context.colorScheme.onSurfaceVariant, 
          ),
          icon: const Icon(Icons.info_outline_rounded, size: 24),
          label: const Text('عن المطور'),
          onPressed: () => showAboutDeveloperBottomSheet(context),
        ),
      ],
    );
  }
}