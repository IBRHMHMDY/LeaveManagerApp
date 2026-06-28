import 'package:flutter/material.dart';

enum AlertType { info, warning, error }

class CustomAlertBanner extends StatelessWidget {
  final String message;
  final AlertType type;

  const CustomAlertBanner({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    Color baseColor;
    IconData iconData;

    // تحديد اللون الأساسي حسب النوع (ألوان أفتح قليلاً في الوضع الليلي للوضوح)
    switch (type) {
      case AlertType.info:
        baseColor = isDark ? Colors.blue.shade400 : Colors.blue.shade600;
        iconData = Icons.info_outline_rounded;
        break;
      case AlertType.warning:
        baseColor = isDark ? Colors.orange.shade400 : Colors.orange.shade600;
        iconData = Icons.warning_amber_rounded;
        break;
      case AlertType.error:
        baseColor = isDark ? Colors.red.shade400 : Colors.red.shade600;
        iconData = Icons.error_outline_rounded;
        break;
    }

    // خلفية شفافة تعتمد على اللون الأساسي لتناسب جميع الثيمات
    final bgColor = baseColor.withAlpha(isDark ? 25 : 15);
    
    // نص يأخذ لون الثيم العام مع إعطائه لمحة من اللون الأساسي
    final textColor = isDark ? Colors.white.withAlpha(240) : baseColor.withAlpha(220);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: baseColor.withAlpha(isDark ? 80 : 40), width: 1),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: baseColor.withAlpha(15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: baseColor.withAlpha(40),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: baseColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}