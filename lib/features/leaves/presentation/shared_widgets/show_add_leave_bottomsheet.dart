// lib/core/utils/helpers/show_add_leave_bottomsheet.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/features/leaves/presentation/shared_widgets/add_leave_form.dart';

void showAddLeaveBottomSheet(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: colorScheme.surface, // التوافق التام مع الثيم
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)), // حواف أكثر دائرية وعصرية
    ),
    builder: (ctx) => Padding(
      // Padding لرفع النافذة عند ظهور لوحة المفاتيح
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: AddLeaveForm(parentContext: context),
    ),
  );
}