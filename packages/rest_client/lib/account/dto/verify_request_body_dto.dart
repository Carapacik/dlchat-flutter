import 'package:json_annotation/json_annotation.dart';

part 'verify_request_body_dto.g.dart';

@JsonSerializable()
class const VerifyRequestBodyDto({
  /// User phone number
  required final String phoneNumber,

  /// OTP code sent to user
  required final String otp,

  /// User device info
  required final VerifyDevice device,
}) {
  factory fromJson(Map<String, Object?> json) => _$VerifyRequestBodyDtoFromJson(json);

  Map<String, Object?> toJson() => _$VerifyRequestBodyDtoToJson(this);
}

@JsonSerializable()
class const VerifyDevice({
  /// Device Identifier
  required final String deviceId,

  /// Device Type
  required final String type,

  /// Operating System Version
  required final String osVersion,

  /// Application Version
  required final String appVersion,

  /// Locale
  required final String locale,

  /// Screen Resolution
  required final String screenResolution,

  /// FCM (Firebase Cloud Messaging) Token
  final String? fcmToken,
}) {
  factory fromJson(Map<String, Object?> json) => _$VerifyDeviceFromJson(json);

  Map<String, Object?> toJson() => _$VerifyDeviceToJson(this);
}
