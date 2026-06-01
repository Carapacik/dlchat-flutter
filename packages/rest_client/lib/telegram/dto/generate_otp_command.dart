// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'generate_otp_command.g.dart';

@JsonSerializable()
class GenerateOtpCommand {
  const GenerateOtpCommand({required this.phoneNumber, required this.telegramUserId});

  factory GenerateOtpCommand.fromJson(Map<String, Object?> json) => _$GenerateOtpCommandFromJson(json);

  /// User phone number
  final String phoneNumber;

  /// Идентификатор пользователя в telegram
  final int telegramUserId;

  Map<String, Object?> toJson() => _$GenerateOtpCommandToJson(this);
}
