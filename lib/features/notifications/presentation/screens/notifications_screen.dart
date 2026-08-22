import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leave_manager/core/constants/app_spacing.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:leave_manager/features/notifications/presentation/bloc/notifications_state.dart';
import 'package:leave_manager/features/notifications/presentation/widgets/notification_card.dart';
import 'package:leave_manager/shared/widgets/widgets.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'الإشعارات'),
      body: BlocConsumer<NotificationsBloc, NotificationsState>(
        listener: (context, state) {
          if (state is NotificationsError) {
            AppToast.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is NotificationsLoading || state is NotificationsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return const AppEmptyState(
                title: 'لا توجد إشعارات',
                content: 'لم تتلقَ أي إشعارات جديدة حتى الآن.',
                icon: Icons.notifications_off_rounded,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: state.notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  notification: state.notifications[index],
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}