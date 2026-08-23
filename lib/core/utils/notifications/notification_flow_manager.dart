// lib/core/utils/notifications/notification_flow_manager.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/holiday_action_bottomsheet.dart';

@lazySingleton
class NotificationFlowManager {
  final NotificationService _notificationService;
  StreamSubscription<NotificationResponse>? _subscription;

  NotificationFlowManager(this._notificationService);

  void init() {
    _subscription?.cancel();

    // 1. التعامل مع الإشعار عند فتح التطبيق من حالة مغلقة (Cold Start)
    if (_notificationService.initialNotificationResponse != null) {
      _handleNotificationResponse(_notificationService.initialNotificationResponse!);
      _notificationService.initialNotificationResponse = null;
    }

    // 2. التعامل مع الإشعار والتطبيق يعمل في الخلفية أو الواجهة
    _subscription = selectNotificationStream.stream.listen((NotificationResponse response) {
      _handleNotificationResponse(response);
    });
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload;

    int? holidayId;
    if (payload != null && payload.startsWith('holiday_')) {
      holidayId = int.tryParse(payload.split('_').last);
    }

    if (holidayId != null) {
      // 1. الانتقال فوراً إلى شاشة العطلات باستخدام GoRouter لتحسين تجربة المستخدم
      AppRouter.router.go(AppRouter.holidays);

      // 2. استخدام المُؤقت (Poller) للانتظار حتى يكتمل تحميل شاشة العطلات
      _executeWhenAppReady(() {
        final context = AppRouter.router.routerDelegate.navigatorKey.currentContext;
        if (context != null && context.mounted) {
          final holidaysState = context.read<HolidaysCubit>().state;
          
          if (holidaysState is HolidaysLoaded) {
            final holiday = holidaysState.financialYearHolidays
                .where((h) => h.id == holidayId)
                .firstOrNull;

            if (holiday != null) {
              // 3. إظهار الـ BottomSheet المخصص لاتخاذ الإجراءات بعد التأكد من جاهزية الواجهة
              showHolidayActionBottomSheet(context, holiday);
            }
          }
        }
      });
    } else {
      // التوجيه الافتراضي لشاشة الإشعارات في حال لم يكن الإشعار مرتبطاً بعطلة
      AppRouter.router.go(AppRouter.notifications);
    }
  }

  /// المُؤقت الذكي (Smart Poller) للتأكد من جاهزية الـ BLoC والواجهة
  void _executeWhenAppReady(VoidCallback action) {
    int attempts = 0;
    // التحقق كل 100 ملي ثانية
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      attempts++;
      final context = AppRouter.router.routerDelegate.navigatorKey.currentContext;

      if (context != null && context.mounted) {
        final holidaysState = context.read<HolidaysCubit>().state;

        // التحقق من أن حالة العطلات تم تحميلها بنجاح (State is Loaded)
        if (holidaysState is HolidaysLoaded) {
          timer.cancel();
          action();
        }
      }

      // إيقاف المحاولة بعد 5 ثوانٍ (50 محاولة) لتجنب تسريب الذاكرة (Memory Leak)
      if (attempts > 50) {
        timer.cancel();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}