import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:leave_manager/core/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class CoreInjectableModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

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
}