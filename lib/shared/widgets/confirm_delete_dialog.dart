import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final String titleDialog;
  final String contentDialog;
  final void Function() onPressedButton;
  
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
      actionsAlignment: MainAxisAlignment.end, // محاذاة الأزرار للنهاية (اليسار في RTL)
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            // إبطال التمدد المفروض من الثيم العام بإرجاع الحجم الأدنى للصفر
            minimumSize: const Size(0, 45), 
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onPressed: () => context.pop(false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 0,
            // إبطال التمدد المفروض من الثيم العام ليأخذ الزر حجم النص فقط
            minimumSize: const Size(0, 45),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onPressed: onPressedButton,
          child: const Text('نعم، حذف'),
        ),
      ],
    );
  }
}