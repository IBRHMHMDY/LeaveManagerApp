// lib/core/utils/app_restarter.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';
import 'package:leave_manager/core/router/app_router.dart';

class AppRestarter extends StatefulWidget {
  final Widget child;
  const AppRestarter({super.key, required this.child});

  /// دالة استدعاء إعادة التشغيل الساخن
  static Future<void> restartApp(BuildContext context) async {
    // 1. إعادة تعيين حقن التبعيات بالكامل (يغلق الاتصالات الحالية)
    await sl.reset();
    
    // 2. إعادة تهيئة الخدمات الأساسية (يفتح اتصال جديد بقاعدة البيانات المستعادة)
    await AppBootstrapper.init();
    
    // 3. توجيه الـ Router للبداية لضمان تفريغ مكدس الصفحات (Navigation Stack)
    AppRouter.router.go(AppRouter.splash);
    
    // 4. إعادة بناء شجرة واجهة المستخدم بالكامل
    context.findAncestorStateOfType<_AppRestarterState>()?.restartApp();
  }

  @override
  State<AppRestarter> createState() => _AppRestarterState();
}

class _AppRestarterState extends State<AppRestarter> {
  Key key = UniqueKey();

  void restartApp() {
    // تغيير الـ Key يجبر Flutter على تدمير الشجرة الحالية وبنائها من الصفر
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}