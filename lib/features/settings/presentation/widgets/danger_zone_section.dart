import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_event.dart';
import 'package:leave_manager/features/settings/presentation/widgets/show_about_developer.dart';
import 'package:leave_manager/shared/widgets/confirm_delete_dialog.dart';
import 'package:leave_manager/shared/widgets/show_toast.dart';

class DangerZoneSection extends StatelessWidget {
  const DangerZoneSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            foregroundColor: Colors.red.shade700,
            side: BorderSide(color: Colors.red.shade700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.delete_forever, size: 18),
          label: const Text(
            'تصفير الأرصدة (مسح سجلات الإجازات)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () => ConfirmDeleteDialog(
            titleDialog: 'تأكيد التصفير',
            contentDialog:
                'هل أنت متأكد من أنك تريد مسح جميع سجلات الإجازات؟ هذا الإجراء لا يمكن التراجع عنه.',
            onPressedButton: () {
              context.read<LeavesBloc>().add(ResetAllLeavesEvent());
              context.pop();
              AppToast.showSuccess(context, 'تم تصفير الأرصدة بنجاح');
            },
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            foregroundColor: colorScheme.onSurface.withAlpha(200),
          ),
          icon: const Icon(Icons.info_outline_rounded),
          label: const Text(
            'عن التطبيق',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onPressed: () => showAboutDeveloperBottomSheet(context),
        ),
      ],
    );
  }

  // void _showConfirmationDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: const Text(),
  //       content: const Text(
  //         'هل أنت متأكد من أنك تريد مسح جميع سجلات الإجازات؟ هذا الإجراء لا يمكن التراجع عنه.',
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => context.pop(ctx),
  //           child: const Text('إلغاء'),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.red,
  //             foregroundColor: Colors.white,
  //             elevation: 0,
  //           ),
  //           onPressed: () {},
  //           child: const Text('نعم، مسح'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
