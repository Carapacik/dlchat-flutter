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
  /// Идентификатор устройства
  required final String deviceId,

  /// Операционная система
  required final String osType,

  /// Версия операционной системы
  required final String osVersion,

  /// Версия приложения
  required final String appVersion,

  /// Разрешение экрана
  required final String screenResolution,

  /// Платформа
  required final SessionPlatform platform,
}) {
  factory fromJson(Map<String, Object?> json) => _$VerifyDeviceFromJson(json);

  Map<String, Object?> toJson() => _$VerifyDeviceToJson(this);
}

/// An enumeration.
@JsonEnum()
enum SessionPlatform(final String? json) {
  @JsonValue('DESKTOP')
  desktop('DESKTOP'),
  @JsonValue('MOBILE')
  mobile('MOBILE'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  factory fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);
}
