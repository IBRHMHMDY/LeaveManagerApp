import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class CheckNetworkInfo {
  Future<bool> get isConnected;
}

@LazySingleton(as: CheckNetworkInfo)
class CheckNetworkInfoImpl implements CheckNetworkInfo {
  final Connectivity connectivity;

  CheckNetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none) && result.length == 1) {
      return false;
    }
    return true;
  }
}