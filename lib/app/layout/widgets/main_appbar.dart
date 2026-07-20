import 'package:flutter/material.dart';

class MainAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
          title: const Text('مدير اجازاتى'),
          centerTitle: true,
        );
  }
  
  @override
  Size get preferredSize => throw UnimplementedError();
}