// lib/features/home/presentation/widgets/build_alert_banners.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_bloc.dart';
import 'package:leave_manager/features/leaves/presentation/blocs/leaves_state.dart';

enum AlertType { info, warning, error }

class BuildAlertBanners extends StatelessWidget {
  final String message;
  final AlertType alertType;

  const BuildAlertBanners({
    super.key,
    required this.alertType,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor;
    IconData iconData;

    switch (alertType) {
      case AlertType.info:
        baseColor = context.colorScheme.primary;
        iconData = Icons.info_outline_rounded;
        break;
      case AlertType.warning:
        baseColor = context.colorScheme.secondary;
        iconData = Icons.warning_amber_rounded;
        break;
      case AlertType.error:
        baseColor = context.colorScheme.error;
        iconData = Icons.error_outline_rounded;
        break;
    }

    final bgColor = baseColor.withOpacity(0.1);
    final textColor = context.colorScheme.onSurface;

    return BlocBuilder<LeavesBloc, LeavesState>(
      builder: (context, state) {
        if (state is LeavesLoaded) {
          List<Widget> alerts = [];
          final currentMonth = DateTime.now().month;

          if (currentMonth == 6) {
            alerts.add(
              ShowAlertBanner(
                bgColor: bgColor,
                baseColor: baseColor,
                iconData: iconData,
                message: message,
                textColor: textColor,
              ),
            );
          }
          return Column(children: alerts);
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ShowAlertBanner extends StatelessWidget {
  const ShowAlertBanner({
    super.key,
    required this.bgColor,
    required this.baseColor,
    required this.iconData,
    required this.message,
    required this.textColor,
  });

  final Color bgColor;
  final Color baseColor;
  final IconData iconData;
  final String message;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.lg,
        border: Border.all(
          color: baseColor.withOpacity(isDark ? 0.3 : 0.15),
          width: 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: baseColor.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: baseColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: baseColor, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
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