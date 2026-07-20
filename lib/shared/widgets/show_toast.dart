// lib/core/utils/app_toast.dart
import 'dart:async';
import 'package:flutter/material.dart';

/// كلاس مسؤول عن إدارة وعرض إشعارات Toast بشكل مستقل عن Scaffold
class AppToast {
  static OverlayEntry? _currentOverlay;
  static Timer? _timer;

  // 1. إشعار النجاح
  static void showSuccess(BuildContext context, String message) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    _showToast(
      context,
      message,
      title: 'عملية ناجحة',
      icon: Icons.check_circle_rounded,
      color: isDark ? Colors.green.shade400 : Colors.green.shade600,
      bgColor: isDark ? Colors.green.withAlpha(30) : Colors.green.shade50,
    );
  }

  // 2. إشعار الخطأ
  static void showError(BuildContext context, String message) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    _showToast(
      context,
      message,
      title: 'عذراً',
      icon: Icons.error_rounded,
      color: isDark ? Colors.red.shade400 : Colors.red.shade600,
      bgColor: isDark ? Colors.red.withAlpha(30) : Colors.red.shade50,
    );
  }

  // 3. إشعار التنبيه
  static void showWarning(BuildContext context, String message) {
    final isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    _showToast(
      context,
      message,
      title: 'تنبيه',
      icon: Icons.warning_rounded,
      color: isDark ? Colors.orange.shade400 : Colors.orange.shade600,
      bgColor: isDark ? Colors.orange.withAlpha(30) : Colors.orange.shade50,
    );
  }

  /// الدالة الأساسية لبناء وعرض الـ Overlay
  static void _showToast(
    BuildContext context,
    String message, {
    required String title,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    // إزالة الإشعار القديم إذا كان موجوداً لتجنب التكدس (UI Clutter)
    _currentOverlay?.remove();
    _timer?.cancel();

    final overlayState = Overlay.of(context);
    
    _currentOverlay = OverlayEntry(
      builder: (context) => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter, // التعديل 1: التوجيه للأسفل
          child: _ToastAnimatedWidget(
            title: title,
            message: message,
            icon: icon,
            color: color,
            bgColor: bgColor,
            onDismissed: _removeToast,
          ),
        ),
      ),
    );

    overlayState.insert(_currentOverlay!);

    // إغلاق تلقائي بعد 4 ثوانٍ
    _timer = Timer(const Duration(seconds: 4), () {
      _removeToast();
    });
  }

  static void _removeToast() {
    _currentOverlay?.remove();
    _currentOverlay = null;
    _timer?.cancel();
    _timer = null;
  }
}

/// الويدجت المسؤولة عن الأنيميشن والشكل البصري للـ Toast
class _ToastAnimatedWidget extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onDismissed;

  const _ToastAnimatedWidget({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onDismissed,
  });

  @override
  State<_ToastAnimatedWidget> createState() => _ToastAnimatedWidgetState();
}

class _ToastAnimatedWidgetState extends State<_ToastAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // إعداد الأنيميشن عند ظهور الـ Toast
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // التعديل 2: أنيميشن احترافي من الأسفل باستخدام Curves.easeOutBack
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5), // يبدأ من أسفل الشاشة
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack, // يضيف تأثير الارتداد (Bounce) الاحترافي
      reverseCurve: Curves.easeInCubic, // تسريع الخروج عند السحب
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  // AMD 2026: تنظيف الموارد لمنع Memory Leaks
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// دالة الإغلاق اليدوي بالسحب (Swipe down to dismiss)
  Future<void> _dismissToast() async {
    // التعديل 3: استخدام async/await بدلاً من .then()
    await _animationController.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            // التعديل 4: الإغلاق يتم عند السحب للأسفل (موجب)
            if (details.primaryDelta! > 5) {
              _dismissToast(); 
            }
          },
          child: Container(
            // التعديل 5: رفع منطقة الإشعار عن حافة الشاشة بشكل ملحوظ
            margin: const EdgeInsets.only(bottom: 90, left: 16, right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.transparent : widget.color.withAlpha(20),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 50 : 10),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isDark ? Colors.white12 : widget.color.withAlpha(40),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent, // ضروري لمنع الخطأ عند استخدام Overlay
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          style: TextStyle(
                            color: colorScheme.onSurface.withAlpha(180),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}