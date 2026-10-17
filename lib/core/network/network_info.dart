// lib/core/network/network_info.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

/// واجهة للتحقق من حالة اتصال الجهاز بالإنترنت.
abstract class NetworkInfo {
  /// ترجع `true` إذا كان الجهاز متصلاً بشبكة (Wi-Fi أو بيانات الهاتف أو Ethernet).
  Future<bool> get isConnected;
}

/// التنفيذ الفعلي لفحص الاتصال باستخدام مكتبة connectivity_plus (الإصدار ^6.1.0).
@LazySingleton(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  /// منشئ الكلاس يستقبل كائن Connectivity المحقون عبر DI.
  const NetworkInfoImpl(this._connectivity);

  @override
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results =
        await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}