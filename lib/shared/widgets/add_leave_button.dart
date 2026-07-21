import 'package:flutter/material.dart';

class AddLeaveButton extends StatelessWidget {
  final void Function() onTap;
  final Widget? icon;
  final Widget label;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AddLeaveButton({super.key, required this.onTap, this.icon, required this.label, this.backgroundColor, this.foregroundColor});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      icon: icon,
      label: label,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }
}

