// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/subscription/dto/payment_method_data_dto.dart';

part 'pay_rate_command.g.dart';

@JsonSerializable()
class PayRateCommand {
  const PayRateCommand({
    required this.rateId,
    required this.specialOfferId,
    required this.promoCode,
    required this.paymentMethod,
    this.email,
  });

  factory PayRateCommand.fromJson(Map<String, Object?> json) => _$PayRateCommandFromJson(json);

  /// Идентификатор тарифа
  final String rateId;

  /// Платежный метод
  final PaymentMethodDataDto paymentMethod;

  /// Промокод
  final String? email;

  /// Идентификатор спец. предложения
  final String? specialOfferId;

  /// Промокод
  final String? promoCode;

  Map<String, Object?> toJson() => _$PayRateCommandToJson(this);
}
