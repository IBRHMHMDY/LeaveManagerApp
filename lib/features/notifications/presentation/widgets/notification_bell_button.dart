// lib/features/notifications/presentation/widgets/notification_bell_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extensions/theme_extension.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:leave_manager/shared/widgets/displays/app_tooltip.dart';

/// زر أيقونة الإشعارات المزود بشارة (Badge) تعرض عدد الإشعارات غير المقروءة.
class NotificationBellButton extends StatelessWidget {
  /// منشئ ثابت للزر.
  const NotificationBellButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<NotificationsBloc, NotificationsState, int>(
      selector: (state) {
        if (state is NotificationsLoaded) {
          return state.unreadCount;
        }
        return 0;
      },
      builder: (context, unreadCount) {
        return AppTooltip(
          message: 'الإشعارات',
          preferBelow: true,
          child: IconButton(
            onPressed: () => context.push(AppRouter.notifications),
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              backgroundColor: context.colorScheme.error,
              textColor: context.colorScheme.onError,
              label: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Icon(
                unreadCount > 0
                    ? Icons.notifications_active_rounded
                    : Icons.notifications_outlined,
                color: context.colorScheme.primary,
                size: 26,
              ),
            ),
          ),
        );
      },
    );
  }
}