// lib/features/notifications/presentation/screens/notifications_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/core/utils/extensions/theme_extension.dart';
import 'package:leave_manager/features/leaves/presentation/widgets/leave_list_shimmer.dart';
import 'package:leave_manager/features/notifications/domain/entities/app_notification_entity.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_event.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:leave_manager/features/notifications/presentation/widgets/notification_card.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// شاشة عرض وإدارة سجل الإشعارات الواردة من نظام AppsNotifiersSystem.
class NotificationsScreen extends StatefulWidget {
  /// منشئ ثابت للشاشة.
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const LoadNotificationsEvent());
  }

  Future<void> _handleNotificationTap(
    BuildContext context,
    AppNotificationEntity notification,
  ) async {
    // 1. تحديد الإشعار كمقروء إذا كان غير مقروء
    if (!notification.isRead) {
      context.read<NotificationsBloc>().add(
            MarkNotificationReadEvent(notification.id),
          );
    }

    // 2. التعامل مع رابط التوجيه (Action URL) إن وجد
    final actionUrl = notification.actionUrl?.trim();
    if (actionUrl == null || actionUrl.isEmpty) return;

    if (actionUrl.startsWith('/')) {
      // توجيه داخلي عبر GoRouter (مثل /holidays أو /rest_allowances)
      if (context.mounted) {
        context.push(actionUrl);
      }
    } else {
      // رابط خارجي عبر متصفح النظام
      final uri = Uri.tryParse(actionUrl);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  void _confirmClearAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AppConfirmDialog(
        title: 'مسح سجل الإشعارات',
        content: 'هل أنت متأكد من رغبتك في مسح جميع الإشعارات نهائياً؟',
        confirmText: 'مسح الكل',
        cancelText: 'إلغاء',
        onConfirm: () {
          context.read<NotificationsBloc>().add(
                const ClearAllNotificationsEvent(),
              );
          dialogContext.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(
        title: 'الإشعارات',
        actions: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            buildWhen: (previous, current) => current is NotificationsLoaded,
            builder: (context, state) {
              if (state is NotificationsLoaded &&
                  state.notifications.isNotEmpty) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.unreadCount > 0)
                      AppTooltip(
                        message: 'تحديد الكل كمقروء',
                        preferBelow: true,
                        child: AppIconButton(
                          icon: Icons.done_all_rounded,
                          onPressed: () {
                            context.read<NotificationsBloc>().add(
                                  const MarkAllNotificationsReadEvent(),
                                );
                          },
                        ),
                      ),
                    AppTooltip(
                      message: 'مسح السجل بالكامل',
                      preferBelow: true,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: context.colorScheme.error,
                          size: 26,
                        ),
                        onPressed: () => _confirmClearAll(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationsActionSuccess) {
            AppToast.showSuccess(context, state.message);
          } else if (state is NotificationsError) {
            AppToast.showError(context, state.message);
          }
        },
        buildWhen: (previous, current) =>
            current is NotificationsLoading ||
            current is NotificationsLoaded ||
            current is NotificationsInitial,
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const LeaveListShimmer();
          }

          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const AppEmptyState(
                title: 'لا توجد إشعارات حالياً',
                content:
                    'ستظهر هنا كافة التنبيهات والتحديثات الهامة الواردة للتطبيق.',
                icon: Icons.notifications_off_outlined,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<NotificationsBloc>()
                    .add(const LoadNotificationsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return NotificationCard(
                    key: ValueKey('notification_card_${notification.id}'),
                    notification: notification,
                    onTap: () => _handleNotificationTap(context, notification),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}