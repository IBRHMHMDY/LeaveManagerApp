import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_state.dart';

class NotificationBadgeAction extends StatelessWidget {
  const NotificationBadgeAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsBloc, NotificationsState>(
      builder: (context, state) {
        int unreadCount = 0;
        
        // استخراج عدد الإشعارات غير المقروءة من الحالة
        if (state is NotificationsLoaded) {
          unreadCount = state.unreadCount;
        }

        return IconButton(
          onPressed: () => context.push(AppRouter.notifications),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                Icons.notifications_outlined,
                color: context.colorScheme.onSurface,
                size: 26,
              ),
              if (unreadCount > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: context.colorScheme.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.colorScheme.surface,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : '$unreadCount',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colorScheme.onError,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}