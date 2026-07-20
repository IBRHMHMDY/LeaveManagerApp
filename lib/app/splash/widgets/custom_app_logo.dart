import 'package:flutter/material.dart';

class CustomAppLogo extends StatelessWidget {
  final BuildContext? context;
  const CustomAppLogo(this.context,{super.key });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
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
            size: 60,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          // دائرة وعلامة صح متداخلة (Layered Icon)
          Positioned(
            bottom: 25,
            right: 22,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(25), blurRadius: 4),
                ],
              ),
              child: Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
