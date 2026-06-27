import 'package:flutter/material.dart';
import 'package:vacation_tracker/presentation/widgets/add_leave_form.dart';

void showAddLeaveBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: AddLeaveForm(parentContext: context),
    ),
  );
}
