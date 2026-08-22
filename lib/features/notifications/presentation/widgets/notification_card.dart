import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extenstions/date_extension.dart';
import 'package:leave_manager/core/utils/extenstions/theme_extension.dart';
import 'package:leave_manager/features/notifications/domain/entities/notification_entity.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('notification_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: context.colorScheme.error,
          borderRadius: AppRadius.lg,
        ),
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Icon(Icons.delete_sweep_rounded, color: context.colorScheme.onError, size: 28),
      ),
      onDismissed: (_) {
        context.read<NotificationsBloc>().add(DeleteNotificationEvent(notification.id));
      },
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        backgroundColor: notification.isRead 
            ? context.colorScheme.surface 
            : context.colorScheme.primaryContainer.withOpacity(0.15),
        indicatorColor: notification.isRead ? Colors.transparent : context.colorScheme.primary,
        onTap: () {
          if (!notification.isRead) {
            context.read<NotificationsBloc>().add(MarkNotificationAsReadEvent(notification.id));
          }
          // هنا يمكنك إضافة منطق التوجيه بناءً على الـ Payload إذا لزم الأمر
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  notification.createdAt.toFormatDayMonth(),
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              notification.body,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}