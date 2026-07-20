import 'package:package_info_plus/package_info_plus.dart';

class AppInfoHelper {
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