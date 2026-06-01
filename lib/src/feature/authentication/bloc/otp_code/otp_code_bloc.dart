import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/authentication/model/app_device_info.dart';
import 'package:dlchat/src/feature/authentication/model/input_phone_data.dart';
import 'package:dlchat/src/feature/system/data/device_info_repository.dart';
import 'package:dlchat/src/feature/system/model/os_type.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rest_client/auth/dto/verify_request_body_dto.dart';

part 'otp_code_bloc.freezed.dart';
part 'otp_code_event.dart';
part 'otp_code_state.dart';

final class OtpCodeBloc({
  required final String _phone,
  required final IAuthenticationRepository _authenticationRepository,
  required final IDeviceInfoRepository _deviceInfoRepository,
  required final PackageInfo _packageInfo,
  required final IUserRepository _userRepository,
}) extends Bloc<OtpCodeEvent, OtpCodeState> {
  this : super(const OtpCodeState.idle()) {
    on<_OtpCodeVerifyPressed>(_verifyPressed);
    on<_OtpCodeResent>(_resend);
  }

  Future<void> _verifyPressed(_OtpCodeVerifyPressed event, Emitter<OtpCodeState> emitter) async {
    emitter(const OtpCodeState.processing());
    await ExceptionHandler.handle(
      () async {
        final String appVersion = _packageInfo.version;
        final ({String deviceId, OsType osType, String osVersion}) deviceInfo = await _deviceInfoRepository.deviceInfo;
        final SessionPlatform platform = kIsWeb || (Platform.isLinux || Platform.isWindows || Platform.isMacOS)
            ? SessionPlatform.desktop
            : SessionPlatform.mobile;
        await _authenticationRepository.signIn(
          _phone,
          event.code,
          AppDeviceInfo(
            appVersion: appVersion,
            deviceId: deviceInfo.deviceId,
            osType: deviceInfo.osType.json,
            osVersion: deviceInfo.osVersion,
            screenResolution: event.screenResolution,
            platform: platform,
          ),
        );
        await _userRepository.savePhone(_phone);
        emitter(const OtpCodeState.success());
      },
      onError: (exception, stackTrace) => emitter(OtpCodeState.failure(exception: exception)),
      onDone: () => emitter(const OtpCodeState.idle()),
    );
  }

  Future<void> _resend(_OtpCodeResent event, Emitter<OtpCodeState> emitter) async =>
      await _authenticationRepository.initPhone(_phone, SignInType.sms);
}
