import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_extra_work_bottomsheet.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_rest_allowances_bottomsheet.dart';

class RestActionButtons extends StatelessWidget {
  const RestActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xE07C4DFF),
                  foregroundColor: colorScheme.onSurface,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: () => showAddExtraWorkBottomSheet(context),
                icon:  Icon(Icons.add, color: isDark? colorScheme.onSurface : colorScheme.onPrimary, size: 20.sp),
                label: Text('اضافى/عطله', style:  TextStyle(color: isDark? colorScheme.onSurface : colorScheme.surface, fontSize: 15.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xE07C4DFF),
                  foregroundColor: colorScheme.onSurface,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: () => showRestAllowancesBottomSheet(context),
                icon:  Icon(Icons.add, size: 20.sp, color: isDark? colorScheme.onSurface : colorScheme.surface,),
                label: Text('بدل راحه', style: TextStyle(color: isDark? colorScheme.onSurface : colorScheme.surface, fontSize: 15.sp, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}