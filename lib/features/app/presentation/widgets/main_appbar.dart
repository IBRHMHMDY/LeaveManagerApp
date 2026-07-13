import 'package:flutter/material.dart';

// 1. إضافة implements PreferredSizeWidget
class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('مدير الإجازات'), // أضف العنوان المناسب لتطبيقك
      centerTitle: true,
    );
  }

  // 2. توفير الارتفاع المفضل (Preferred Size) للـ AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}