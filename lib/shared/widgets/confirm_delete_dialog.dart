import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String titleDialog;
  final String contentDialog;
  final VoidCallback onPressedButton;

  const ConfirmDeleteDialog({
    super.key,
    required this.titleDialog,
    required this.contentDialog,
    required this.onPressedButton,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleDialog),
      content: Text(contentDialog),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: context.colorScheme.error,
            foregroundColor: context.colorScheme.onError,
            elevation: 0,
          ),
          onPressed: onPressedButton,
          child: const Text('تأكيد الحذف'),
        ),
      ],
    );
  }
}