import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

abstract class DeviceIdentityService {
  Future<String> getDeviceId();
}

@LazySingleton(as: DeviceIdentityService)
class DeviceIdentityServiceImpl implements DeviceIdentityService {
  final FlutterSecureStorage _secureStorage;
  static const String _deviceIdKey = 'secure_device_id';

  const DeviceIdentityServiceImpl(this._secureStorage);

  @override
  Future<String> getDeviceId() async {
    String? deviceId = await _secureStorage.read(key: _deviceIdKey);
    
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = const Uuid().v4();
      await _secureStorage.write(key: _deviceIdKey, value: deviceId);
    }
    
    return deviceId;
  }
}