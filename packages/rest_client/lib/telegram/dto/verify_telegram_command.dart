// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'verify_telegram_command.g.dart';

@JsonSerializable()
class VerifyTelegramCommand {
  const VerifyTelegramCommand({required this.otp});

  factory VerifyTelegramCommand.fromJson(Map<String, Object?> json) => _$VerifyTelegramCommandFromJson(json);

  /// OTP код
  final String otp;

  Map<String, Object?> toJson() => _$VerifyTelegramCommandToJson(this);
}
