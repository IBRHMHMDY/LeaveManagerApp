import 'package:flutter/material.dart';

class ShowBottomSheet {
  /// يعرض [BottomSheet] مخصص مع زوايا دائرية، ومقبض سحب، ويدعم التكيف مع لوحة المفاتيح
  static Future<T?> show<T>({
    required BuildContext context,
    required IconData? icon,
    required String? title,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      backgroundColor:
          Colors.transparent, // لجعل الزوايا الدائرية تظهر بشكل صحيح
      useSafeArea: true, // يمنع تداخل الواجهة مع شريط الحالة أو النوتش
      builder: (BuildContext ctx) {
        return Padding(
          // هذا السطر يضمن ارتفاع الـ BottomSheet عند فتح لوحة المفاتيح
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _GenericBottomSheetContent(
            title: title,
            icon: Icons.edit_calendar_rounded,
            child: child,
          ),
        );
      },
    );
  }
}

/// الويدجت الداخلية التي تبني الهيكل المرئي للـ BottomSheet
class _GenericBottomSheetContent extends StatelessWidget {
  final String? title;
  final IconData icon;
  final Widget child;

  const _GenericBottomSheetContent({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      // تحديد أقصى ارتفاع للـ BottomSheet ليكون 90% من الشاشة
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          // 1. مقبض السحب (Drag Handle)
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
