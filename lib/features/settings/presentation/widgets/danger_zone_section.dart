// lib/features/settings/presentation/widgets/danger_zone_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_bloc.dart';
import 'package:leave_manager/features/rest_allowances/presentation/blocs/rest_allowances_event.dart';
import 'package:leave_manager/features/settings/presentation/widgets/about_developer_bottomsheet.dart';
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
          label: 'حذف جميع السجلات',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AppConfirmDialog(
                  title: 'تحذير الحذف',
                  content: 'هل أنت متأكد من رغبتك في حذف جميع سجلات الإجازات والبدلات نهائياً؟ لا يمكن التراجع عن هذه الخطوة.',
                  confirmText: 'نعم، احذف',
                  cancelText: 'إلغاء',
                  onConfirm: () {
                    // 1. استدعاء حدث مسح السجلات من الـ DB
                    context.read<LeavesBloc>().add(ResetAllLeavesEvent());
                    
                    // 2. تحديث حالة الـ RestAllowancesBloc لتفريغ الـ UI
                    context.read<RestAllowancesBloc>().add(LoadRestAllowancesEvent());
                    
                    dialogContext.pop();
                    AppToast.showSuccess(context, 'تم حذف جميع السجلات بنجاح.');
                  },
                );
              },
            );
          },
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