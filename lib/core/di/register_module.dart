// lib/core/di/register_module.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// موديول لتسجيل المكتبات والخدمات الخارجية في حاوية حقن التبعيات (GetIt).
@module
abstract class RegisterModule {
  /// تهيئة SharedPreferences بشكل مسبق قبل تشغيل التطبيق.
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// توفير نسخة وحيدة من قاعدة بيانات Drift.
  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  /// توفير نسخة وحيدة من التخزين الآمن لحفظ الـ FCM Token ببيئة مشفرة.
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  /// توفير خدمة فحص حالة الاتصال بالشبكة.
  @lazySingleton
  Connectivity get connectivity => Connectivity();
}