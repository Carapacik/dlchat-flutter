// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/subscription/dto/payment_method_type_dto.dart';

import 'payment_state.dart';

part 'payment_dto.g.dart';

@JsonSerializable()
class PaymentDto {
  const PaymentDto({
    required this.id,
    required this.amount,
    required this.method,
    required this.state,
    required this.createdAt,
    this.url,
  });

  factory PaymentDto.fromJson(Map<String, Object?> json) => _$PaymentDtoFromJson(json);

  /// Идентификатор платежа
  final String id;

  /// Сумма платежа (в минимальных единицах валюты)
  final int amount;

  /// Тип платежа
  final PaymentMethodTypeDto method;

  /// Состояние платежа
  final PaymentStateDto state;

  /// Ссылка на платеж
  final String? url;

  /// Дата создания платежа
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$PaymentDtoToJson(this);
}
