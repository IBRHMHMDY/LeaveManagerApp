// lib/core/utils/notifications/notification_flow_manager.dart
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/router/app_router.dart';
import 'package:leave_manager/core/utils/notifications/notification_service.dart';

@lazySingleton
class NotificationFlowManager {
  final NotificationService _notificationService;
  
  // جعل المنفذ final وتجنب استخدام المتغيرات القابلة للتغيير
  final ReceivePort _port = ReceivePort();
  late final StreamSubscription<NotificationResponse> _subscription;

  // سيتم استدعاء الـ Constructor مرة واحدة فقط بفضل @lazySingleton
  NotificationFlowManager(this._notificationService) {
    _initializeDependencies();
  }

  void _initializeDependencies() {
    IsolateNameServer.removePortNameMapping('notification_port');
    IsolateNameServer.registerPortWithName(_port.sendPort, 'notification_port');
    
    _port.listen((dynamic data) {
      if (data is String) {
        final mockResponse = NotificationResponse(
          notificationResponseType: NotificationResponseType.selectedNotification,
          payload: data,
        );
        _handleNotificationResponse(mockResponse);
      }
    });

    if (_notificationService.initialNotificationResponse != null) {
      _handleNotificationResponse(
        _notificationService.initialNotificationResponse!,
      );
      _notificationService.initialNotificationResponse = null;
    }

    _subscription = selectNotificationStream.stream.listen((
      NotificationResponse response,
    ) {
      _handleNotificationResponse(response);
    });
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload == null || response.payload!.isEmpty) {
      // نستخدم push للحفاظ على MainLayout في الـ Stack
      AppRouter.router.push(AppRouter.notifications); 
      return;
    }
    try {
      final Map<String, dynamic> payloadData = jsonDecode(response.payload!);
      final type = payloadData['type'] as String?;
      if (type == 'holiday_alert') {
        final holidayIdStr = payloadData['holidayId'];
        final holidayId = holidayIdStr != null
            ? int.tryParse(holidayIdStr.toString())
            : null;
        if (holidayId != null) {
          _handleHolidayRouting(holidayId);
        }
      } else {
        AppRouter.router.push(AppRouter.notifications);
      }
    } catch (e, stackTrace) {
      debugPrint('Error parsing notification payload: $e\n$stackTrace');
      AppRouter.router.push(AppRouter.notifications);
    }
  }

  void _handleHolidayRouting(int holidayId) {
    AppRouter.router.push(
      AppRouter.holidays,
      extra: {'showHolidayId': holidayId},
    );
  }

  void dispose() {
    _subscription.cancel();
    IsolateNameServer.removePortNameMapping('notification_port');
    _port.close();
  }
}