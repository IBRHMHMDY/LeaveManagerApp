import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leave_manager/core/database/app_database.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  Connectivity get connectivity => Connectivity();
}