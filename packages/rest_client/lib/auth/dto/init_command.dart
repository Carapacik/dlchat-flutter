// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'init_type.dart';

part 'init_command.g.dart';

@JsonSerializable()
class InitCommand {
  const InitCommand({required this.phoneNumber, required this.type});

  factory InitCommand.fromJson(Map<String, Object?> json) => _$InitCommandFromJson(json);

  /// User phone number
  final String phoneNumber;

  /// Выбор через что получить OTP
  final InitType type;

  Map<String, Object?> toJson() => _$InitCommandToJson(this);
}
