// lib/features/notifications/presentation/widgets/notification_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extensions/date_extension.dart';
import 'package:leave_manager/core/utils/extensions/theme_extension.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

/// بطاقة عرض إشعار مفرد مع دعم السحب للحذف (Dismissible) وتمييز غير المقروء.
class NotificationCard extends StatelessWidget {
  /// كيان الإشعار المراد عرضه.
  final AppNotificationEntity notification;

  /// دالة رد نداء عند النقر على الإشعار.
  final VoidCallback onTap;

  /// منشئ ثابت للبطاقة.
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;
    final indicatorColor = isUnread
        ? context.colorScheme.primary
        : context.colorScheme.outlineVariant;

    return Dismissible(
      key: ValueKey('notification_item_${notification.id}'),
      direction: DismissDirection.endToStart,
      background: const _NotificationDismissBackground(),
      confirmDismiss: (_) => _showConfirmDeleteDialog(context),
      onDismissed: (_) {
        context.read<NotificationsBloc>().add(
              DeleteNotificationItemEvent(notification.id),
            );
      },
      child: AppCard(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        indicatorColor: indicatorColor,
        backgroundColor: isUnread
            ? context.colorScheme.primary.withAlpha(12)
            : context.colorScheme.surface,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationHeader(notification: notification),
            const SizedBox(height: AppSpacing.sm),
            Text(
              notification.body,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isUnread
                    ? context.colorScheme.onSurface
                    : context.colorScheme.onSurfaceVariant,
                fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                height: 1.5,
              ),
            ),
            if (notification.imageUrl != null &&
                notification.imageUrl!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _NotificationImagePreview(imageUrl: notification.imageUrl!),
            ],
            const SizedBox(height: AppSpacing.sm),
            _NotificationFooter(
              receivedAt: notification.receivedAt,
              hasAction: notification.actionUrl != null &&
                  notification.actionUrl!.trim().isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDeleteDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (ctx) => AppConfirmDialog(
        title: 'حذف الإشعار',
        content: 'هل أنت متأكد من رغبتك في حذف هذا الإشعار من السجل؟',
        confirmText: 'حذف',
        cancelText: 'إلغاء',
        onConfirm: () => ctx.pop(true),
      ),
    );
  }
}

/// خلفية السحب للحذف المتوافقة مع LeaveCard.
class _NotificationDismissBackground extends StatelessWidget {
  const _NotificationDismissBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colorScheme.error,
        borderRadius: AppRadius.lg,
      ),
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Icon(
        Icons.delete_sweep_rounded,
        color: context.colorScheme.onError,
        size: 28,
      ),
    );
  }
}

/// رأس البطاقة ويعرض الأيقونة، العنوان، وشارة "جديد" للإشعار غير المقروء.
class _NotificationHeader extends StatelessWidget {
  final AppNotificationEntity notification;

  const _NotificationHeader({required this.notification});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: isUnread
                ? context.colorScheme.primary.withAlpha(30)
                : context.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isUnread
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
            size: 20,
            color: isUnread
                ? context.colorScheme.primary
                : context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              notification.title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: isUnread ? FontWeight.w900 : FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        if (isUnread) ...[
          const SizedBox(width: AppSpacing.xs),
          const AppBadge(title: 'جديد'),
        ],
      ],
    );
  }
}

/// معاينة الصورة المرفقة بالإشعار مع معالجة التحميل والخطأ بأمان.
class _NotificationImagePreview extends StatelessWidget {
  final String imageUrl;

  const _NotificationImagePreview({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.md,
      child: Image.network(
        imageUrl,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}

/// تذييل البطاقة ويعرض تاريخ الاستلام ومؤشر وجود رابط تفاعلي.
class _NotificationFooter extends StatelessWidget {
  final DateTime receivedAt;
  final bool hasAction;

  const _NotificationFooter({
    required this.receivedAt,
    required this.hasAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 14,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              receivedAt.toFormatFullDaysDate(),
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        if (hasAction)
          Row(
            children: [
              Text(
                'عرض التفاصيل',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.open_in_new_rounded,
                size: 14,
                color: context.colorScheme.primary,
              ),
            ],
          ),
      ],
    );
  }
}