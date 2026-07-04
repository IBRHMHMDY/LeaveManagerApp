import 'package:flutter/material.dart';

class CustomAppLogoIcon extends StatelessWidget {
  final BuildContext? context;
  const CustomAppLogoIcon(this.context,{super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withAlpha(150),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withAlpha(80),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // أيقونة التقويم الرئيسية
          Icon(
            Icons.calendar_month_rounded,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          // دائرة وعلامة صح متداخلة (Layered Icon)
          Positioned(
            bottom: 10,
            right: 12,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 4),
                ],
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
