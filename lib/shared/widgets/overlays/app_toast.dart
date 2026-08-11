// lib/shared/widgets/show_toast.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class AppToast {
  static OverlayEntry? _currentOverlay;
  static Timer? _timer;

  static void showSuccess(BuildContext context, String message) {
    _showToast(
      context,
      message,
      title: 'نجاح',
      icon: Icons.check_circle_rounded,
      color: context.colorScheme.primary,
      bgColor: context.colorScheme.primary.withOpacity(0.12),
    );
  }

  static void showError(BuildContext context, String message) {
    _showToast(
      context,
      message,
      title: 'خطأ',
      icon: Icons.error_rounded,
      color: context.colorScheme.error,
      bgColor: context.colorScheme.error.withOpacity(0.12),
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showToast(
      context,
      message,
      title: 'تنبيه',
      icon: Icons.warning_rounded,
      color: context.colorScheme.secondary,
      bgColor: context.colorScheme.secondary.withOpacity(0.12),
    );
  }

  static void _showToast(
    BuildContext context,
    String message, {
    required String title,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    _currentOverlay?.remove();
    _timer?.cancel();

    final overlayState = Overlay.of(context, rootOverlay: true);
    
    _currentOverlay = OverlayEntry(
      builder: (context) => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _dismissToast() async {
    await _animationController.reverse();
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 5) {
              _dismissToast();
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 90, left: 16, right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.08), // استبدال withAlpha
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: context.colorScheme.shadow.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: context.colorScheme.outline.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
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
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
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