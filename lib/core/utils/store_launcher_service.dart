// lib/core/utils/store_launcher_service.dart
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/errors/failures.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class StoreLauncherService {
  Future launchPlayStore({required String appId}) async {
    try {
      final Uri playStoreUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=$appId',
      );

      if (await launchUrl(playStoreUri, mode: LaunchMode.externalApplication)) {
        return const Right(unit);
      } else {
        return const Left(ServerFailure('تعذر فتح متجر التطبيقات.'));
      }
    } catch (e) {
      debugPrint('Store Launcher Error: $e');
      return const Left(ServerFailure('حدث خطأ غير متوقع أثناء فتح المتجر.'));
    }
  }
}