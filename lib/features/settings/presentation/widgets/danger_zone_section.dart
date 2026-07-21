import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SizedBox(height: 16.h),
        const Divider(),
        SizedBox(height: 16.h),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            foregroundColor: Colors.red.shade700,
            side: BorderSide(color: Colors.red.shade700),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          icon: Icon(Icons.delete_forever, size: 24.sp),
          label: Text(
            'تصفير الأرصدة (مسح سجلات الإجازات)',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          onPressed: (){
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return ConfirmDeleteDialog(
                  titleDialog: 'تأكيد التصفير',
                  contentDialog:
                      'هل أنت متأكد من أنك تريد مسح جميع سجلات الإجازات؟ هذا الإجراء لا يمكن التراجع عنه.',
                  onPressedButton: () {
                    // 1. إرسال الحدث للـ BLoC
                    context.read<LeavesBloc>().add(ResetAllLeavesEvent());
                    // 2. إغلاق الـ Dialog باستخدام الـ context الخاص به
                    dialogContext.pop();
                    // 3. عرض رسالة النجاح
                    AppToast.showSuccess(context, 'تم تصفير الأرصدة بنجاح');
                  },
                );
              },
            );
          }
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            foregroundColor: colorScheme.onSurface.withAlpha(200),
          ),
          icon: Icon(Icons.info_outline_rounded, size: 24.sp,),
          label: Text(
            'عن التطبيق',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          onPressed: () => showAboutDeveloperBottomSheet(context),
        ),
      ],
    );
  }
}
