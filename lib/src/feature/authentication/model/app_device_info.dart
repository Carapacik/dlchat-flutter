import 'package:rest_client/auth/dto/verify_request_body_dto.dart';

class const AppDeviceInfo({
  required final String deviceId,
  required final String osType,
  required final String osVersion,
  required final String appVersion,
  required final String screenResolution,
  required final SessionPlatform platform,
}) {
  static VerifyDevice encode(AppDeviceInfo data) => VerifyDevice(
    deviceId: data.deviceId,
    osType: data.osType,
    osVersion: data.osVersion,
    appVersion: data.appVersion,
    screenResolution: data.screenResolution,
    platform: data.platform,
  );

  @override
  String toString() =>
      'AppDeviceInfo(deviceId: $deviceId, '
      'type: $osType, '
      'osVersion: $osVersion, '
      'appVersion: $appVersion, '
      'screenResolution: $screenResolution)';
}
