// lib/features/rest_allowances/presentation/widgets/rest_allowance_tabs.dart
import 'package:flutter/material.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';

class RestAllowanceTabs extends StatelessWidget {
  final bool showAvailables;
  final int availablesCount;
  final int usageCount;
  final ValueChanged<bool> onChanged;

  const RestAllowanceTabs({
    super.key,
    required this.showAvailables,
    required this.availablesCount,
    required this.usageCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              title: 'اضافى/عطلات ($availablesCount)',
              isActive: showAvailables,
              onTap: () => onChanged(true),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _TabButton(
              title: 'بدلات الراحه ($usageCount)',
              isActive: !showAvailables,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({required this.title, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final restColor = context.leaveColors.restAllowance;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isActive ? restColor : Colors.transparent,
          borderRadius: AppRadii.md,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            color: isActive ? context.colorScheme.onPrimary : restColor,
          ),
        ),
      ),
    );
  }
}