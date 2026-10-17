// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection_container.config.dart';

/// نسخة وحيدة من محدد المواقع الخدمي (Service Locator - GetIt).
final sl = GetIt.instance;

/// تهيئة وتوليد كافة التبعيات المسجلة عبر Injectable.
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => await sl.init();