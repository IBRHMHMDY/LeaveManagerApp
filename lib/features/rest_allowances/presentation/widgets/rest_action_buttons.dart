import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/add_earned_rest_bottomsheet.dart';
import 'package:leave_manager/features/rest_allowances/presentation/widgets/consume_rest_bottomsheet.dart';

class RestActionButtons extends StatelessWidget {
  const RestActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: () => showAddEarnedRestBottomSheet(context),
                icon: const Icon(Icons.add),
                label: Text('يوم عمل اضافى', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                onPressed: () => showConsumeRestBottomSheet(context),
                icon: const Icon(Icons.add),
                label: Text('بدل راحه', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}