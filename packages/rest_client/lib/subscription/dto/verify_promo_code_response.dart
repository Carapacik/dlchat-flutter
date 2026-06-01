// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/subscription/dto/promo_code_or_license_dto.dart';

part 'verify_promo_code_response.g.dart';

@JsonSerializable()
class VerifyPromoCodeResponse {
  const VerifyPromoCodeResponse({required this.promoCode});

  factory VerifyPromoCodeResponse.fromJson(Map<String, Object?> json) => _$VerifyPromoCodeResponseFromJson(json);

  /// Данные промокода
  final PromoCodeOrLicenseDto promoCode;

  Map<String, Object?> toJson() => _$VerifyPromoCodeResponseToJson(this);
}
