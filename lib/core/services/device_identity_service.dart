// lib/core/services/device_identity_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class DeviceIdentityService {
  final FlutterSecureStorage _storage;
  static const String _deviceIdKey = 'secure_device_uuid_id';

  DeviceIdentityService(this._storage);

  Future<String> getDeviceId() async {
    String? deviceId = await _storage.read(key: _deviceIdKey);
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await _storage.write(key: _deviceIdKey, value: deviceId);
    }
    return deviceId;
  }
}