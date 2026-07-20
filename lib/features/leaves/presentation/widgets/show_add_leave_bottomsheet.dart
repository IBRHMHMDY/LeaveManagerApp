// lib/core/utils/helpers/show_add_leave_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/add_leave_form.dart';
import 'package:leave_manager/shared/widgets/show_bottom_sheet.dart';

void showAddLeaveBottomSheet(BuildContext context) {
  ShowBottomSheet.show(
    isDismissible: true,
    context: context,
    title: 'تسجيل اجازه جديده',
    icon: Icons.edit_calendar_rounded,
    isScrollControlled: true,
    child: const AddLeaveForm(),
  );
}
