import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_cubit.dart';
import 'package:leave_manager/features/holidays/presentation/cubit/holidays_state.dart';
import 'package:leave_manager/features/holidays/presentation/widgets/holiday_action_bottomsheet.dart';

@lazySingleton
class NotificationFlowManager {
  final NotificationService _notificationService;
  
  StreamSubscription<NotificationResponse>? _subscription;
  StreamSubscription<HolidaysState>? _holidaysSubscription;

  NotificationFlowManager(this._notificationService);

  void init() {

    _subscription?.cancel();
    
    if (_notificationService.initialNotificationResponse != null) {
      _handleNotificationResponse(_notificationService.initialNotificationResponse!);
      _notificationService.initialNotificationResponse = null;
    }

    _subscription = selectNotificationStream.stream.listen((NotificationResponse response) {
      _handleNotificationResponse(response);
    });
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload == null || response.payload!.isEmpty) {
      AppRouter.router.go(AppRouter.notifications);
      return;
    }

    try {
      final Map<String, dynamic> payloadData = jsonDecode(response.payload!);
      final type = payloadData['type'] as String?;

      if (type == 'holiday_alert') {
        final holidayIdStr = payloadData['holidayId'];
        final holidayId = holidayIdStr != null ? int.tryParse(holidayIdStr.toString()) : null;
        
        if (holidayId != null) {
          _handleHolidayRouting(holidayId);
        }
      } else {
        AppRouter.router.go(AppRouter.notifications);
      }
    } catch (e, stackTrace) {
      debugPrint('Error parsing notification payload: $e\n$stackTrace');
      AppRouter.router.go(AppRouter.notifications);
    }
  }

  void _handleHolidayRouting(int holidayId) {
    AppRouter.router.go(AppRouter.holidays);

    final holidaysCubit = sl<HolidaysCubit>();
    
    void checkAndShow(HolidaysState state) {
      if (state is HolidaysLoaded) {
        final holiday = state.financialYearHolidays.where((h) => h.id == holidayId).firstOrNull;
        
        if (holiday != null) {
          // إضافة تأخير زمني 600 مللي ثانية لضمان انتهاء أنيميشن GoRouter وبناء الشاشة
          Future.delayed(const Duration(milliseconds: 600), () {
            final context = AppRouter.router.routerDelegate.navigatorKey.currentContext;
            if (context != null && context.mounted) {
              showHolidayActionBottomSheet(context, holiday);
            }
          });
        }
        _holidaysSubscription?.cancel();
      }
    }

    if (holidaysCubit.state is HolidaysLoaded) {
      checkAndShow(holidaysCubit.state);
    } else {
      _holidaysSubscription?.cancel();
      _holidaysSubscription = holidaysCubit.stream.listen((state) {
        checkAndShow(state);
      });
    }
  }

  void dispose() {
    _subscription?.cancel();
    _holidaysSubscription?.cancel();
  }
}