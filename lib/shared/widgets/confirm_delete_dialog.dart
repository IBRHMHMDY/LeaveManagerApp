import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String titleDialog;
  final String contentDialog;
  final void Function() onPressedButton;
  const ConfirmDeleteDialog({super.key, required this.titleDialog, required this.contentDialog, required this.onPressedButton});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleDialog),
      content: Text(contentDialog),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          onPressed: () => onPressedButton(), 
          child: const Text('نعم، حذف'),
        ),
      ],
    );
  }
}
