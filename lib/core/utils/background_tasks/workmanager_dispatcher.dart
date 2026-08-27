// lib/core/utils/background_tasks/workmanager_dispatcher.dart
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:leave_manager/core/usecases/base_usecase.dart';
import 'package:leave_manager/core/utils/app_bootstrapper.dart';
import 'package:leave_manager/core/di/injection_container.dart';
import 'package:leave_manager/features/notifications/domain/usecases/check_daily_alerts_usecase.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      debugPrint("WorkManager: بدأ تنفيذ المهمة $taskName");

      // تهيئة الـ Isolate الخلفي: نحتاج لحقن الاعتماديات وقاعدة البيانات تماماً كالتطبيق الأساسي
      await AppBootstrapper.init();

      if (taskName == "com.ibrahimhamdy.leavemanager.dailyAlertsTask") {
        // سحب الـ UseCase من الـ GetIt المجهز
        final checkAlerts = sl<CheckDailyAlertsUseCase>();
        await checkAlerts(const NoParams());
      }

      return Future.value(true);
    } catch (e) {
      debugPrint("WorkManager: فشل تنفيذ المهمة $e");
      return Future.value(false); // سيحاول النظام إعادة تشغيلها لاحقاً
    }
  });
}