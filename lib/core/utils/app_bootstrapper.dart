// lib/core/utils/app_bootstrapper.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:leave_manager/core/di/injection_container.dart';

/// مسؤول عن تهيئة كافة الخدمات الأساسية قبل استدعاء runApp.
abstract final class AppBootstrapper {
  /// تهيئة إطارات العمل، متغيرات البيئة، Firebase، وحقن التبعيات.
  static Future<void> init() async {
    // 1. تهيئة ربط Flutter مع الـ Native
    WidgetsFlutterBinding.ensureInitialized();

    // 2. تحميل متغيرات البيئة من ملف .env
    try {
      await dotenv.load(fileName: '.env');
    } catch (e, stackTrace) {
      debugPrint('DotEnv Load Warning: $e\n$stackTrace');
    }

    // 3. تهيئة خدمات Firebase
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
    } catch (e, stackTrace) {
      debugPrint('Firebase Init Warning: $e\n$stackTrace');
    }

    // 4. تهيئة حاوية حقن التبعيات (GetIt / Injectable)
    await configureDependencies();
  }
}