// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'verify_promo_code_command.g.dart';

@JsonSerializable()
class VerifyPromoCodeCommand {
  const VerifyPromoCodeCommand({required this.promoCode});

  factory VerifyPromoCodeCommand.fromJson(Map<String, Object?> json) => _$VerifyPromoCodeCommandFromJson(json);

  /// Промокод
  final String promoCode;

  Map<String, Object?> toJson() => _$VerifyPromoCodeCommandToJson(this);
}
