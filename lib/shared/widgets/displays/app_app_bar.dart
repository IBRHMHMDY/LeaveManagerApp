// lib/shared/widgets/displays/app_app_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

/// ويدجت عامة لـ AppBar تدعم التخصيص الكامل للعنوان، الأيقونات، والتوسيط.
/// مطابقة لمعايير Flutter 2026 (Immutable State, Const Constructors, Null Safety).
class AppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? customTitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final double toolbarHeight;

  const AppAppBar({
    super.key,
    this.title,
    this.customTitle,
    this.actions,
    this.leading,
    this.centerTitle = true, // التوسيط كقيمة افتراضية
    this.backgroundColor,
    this.elevation = 0,
    this.toolbarHeight = 80.0, // متوافق مع ارتفاع MainAppBar الحالي
  });

  @override
  Widget build(BuildContext context) {
    final isNotHome = GoRouterState.of(context).uri.toString() != AppRouter.home;
    return AppBar(
      toolbarHeight: toolbarHeight,
      elevation: elevation,
      backgroundColor: backgroundColor ?? Colors.transparent,
      centerTitle: centerTitle,
      leading: leading ?? (isNotHome ? IconButton(
        icon: Icon(Icons.arrow_back, color: context.colorScheme.primary),
        onPressed: () => context.go(AppRouter.home),
      ) : null),
      actions: actions,
      title: customTitle ??
          (title != null
              ? Text(
                  title!,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.primary,
                  ),
                )
              : null),
      
    );
  }

  // تطبيق واجهة PreferredSizeWidget لتحديد ارتفاع الـ AppBar
  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight);
}