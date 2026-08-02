// lib/shared/widgets/show_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';

class ShowBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required IconData? icon,
    required Color? iconColor,
    required String? title,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (BuildContext ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: _GenericBottomSheetContent(
            title: title,
            icon: Icons.edit_calendar_rounded,
            iconColor: iconColor,
            child: child,
          ),
        );
      },
    );
  }
}

class _GenericBottomSheetContent extends StatelessWidget {
  final String? title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;

  const _GenericBottomSheetContent({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
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
                color: context.colorScheme.onSurface.withOpacity(
                  0.2,
                ), // استبدال withAlpha
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: AppSpacing.sm),
                Text(
                  title!,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
