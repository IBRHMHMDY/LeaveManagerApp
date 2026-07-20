import 'package:package_info_plus/package_info_plus.dart';


class AppInfoHelper {
  /// دالة مساعدة لجلب معلومات التطبيق والإصدار الحالي من pubspec.yaml
  static Future<String> getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version; // مثال: 1.0.0
    final String buildNumber = packageInfo.buildNumber; // مثال: 1
    
    return '$version+$buildNumber'; // النتيجة: 1.0.0+1
  }

  /// جلب رقم الإصدار فقط
  static Future<String> getVersionOnly() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// جلب رقم البناء (Build Number) فقط
  static Future<String> getBuildNumberOnly() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }
  static Future<String> getPackagename() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }
}