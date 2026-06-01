// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'activate_license_command.g.dart';

@JsonSerializable()
class ActivateLicenseCommand {
  const ActivateLicenseCommand({required this.license});

  factory ActivateLicenseCommand.fromJson(Map<String, Object?> json) => _$ActivateLicenseCommandFromJson(json);

  /// Лицензия
  final String license;

  Map<String, Object?> toJson() => _$ActivateLicenseCommandToJson(this);
}
