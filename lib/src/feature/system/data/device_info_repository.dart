import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dlchat/src/feature/system/model/os_type.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract interface class IDeviceInfoRepository() {
  Future<({String deviceId, OsType osType, String osVersion})> get deviceInfo;
}

class const DeviceInfoRepository() implements IDeviceInfoRepository {
  @override
  Future<({String deviceId, OsType osType, String osVersion})> get deviceInfo async {
    final deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      return (deviceId: '000', osType: OsType.web, osVersion: '000');
    }
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return (deviceId: androidInfo.id, osType: OsType.android, osVersion: androidInfo.version.release);
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return (
        deviceId: iosInfo.identifierForVendor ?? '${iosInfo.systemName}${iosInfo.model}${iosInfo.name}',
        osType: OsType.ios,
        osVersion: iosInfo.systemVersion,
      );
    }
    if (Platform.isMacOS) {
      final MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      return (
        deviceId: macOsInfo.systemGUID ?? '${macOsInfo.hostName}${macOsInfo.model}${macOsInfo.computerName}',

        osType: OsType.macos,
        osVersion: '${macOsInfo.majorVersion}.${macOsInfo.minorVersion}.${macOsInfo.patchVersion}',
      );
    } else if (Platform.isWindows) {
      final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return (
        deviceId: windowsInfo.deviceId,
        osType: OsType.windows,
        osVersion: '${windowsInfo.majorVersion}.${windowsInfo.minorVersion}',
      );
    } else {
      throw UnimplementedError();
    }
  }
}
