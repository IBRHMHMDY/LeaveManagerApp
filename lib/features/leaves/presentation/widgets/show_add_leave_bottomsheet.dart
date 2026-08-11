// lib/core/utils/helpers/show_add_leave_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/add_leave_form.dart';
import 'package:leave_manager/shared/widgets/overlays/app_bottom_sheet.dart';

void showAddLeaveBottomSheet(BuildContext context) {
  AppBottomSheet.show(
    isDismissible: true,
    context: context,
    title: 'تسجيل اجازه جديده',
    icon: Icons.edit_calendar_rounded,
    iconColor: context.colorScheme.primary,
    isScrollControlled: true,
    child: const AddLeaveForm(),
  );
}