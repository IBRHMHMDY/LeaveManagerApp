// lib/shared/widgets/custom_tooltip.dart
import 'package:flutter/material.dart';

/// ويدجت مخصص لتلميحات الأدوات (Tooltip) 
/// يعتمد على الـ Theme الخاص بالتطبيق لضمان تناسق التصميم (UI Consistency).
class CustomTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final bool preferBelow;
  final Duration waitDuration;

  const CustomTooltip({
    super.key,
    required this.message,
    required this.child,
    this.preferBelow = false,
    this.waitDuration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Tooltip(
      message: message,
      preferBelow: preferBelow,
      waitDuration: waitDuration, // وقت الانتظار قبل ظهور التلميح
      showDuration: const Duration(seconds: 2), // مدة بقاء التلميح ظاهراً
      triggerMode: TooltipTriggerMode.longPress, // يظهر عند الضغط المطول
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        // لون الخلفية يتكيف مع الوضع الليلي/النهاري
        color: isDark 
            ? Colors.grey.shade800 
            : colorScheme.primary.withAlpha(230),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 80 : 40),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      child: child,
    );
  }
}