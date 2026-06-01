// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/subscription/dto/payment_dto.dart';

part 'payments_dto.g.dart';

@JsonSerializable()
class PaymentsDto {
  const PaymentsDto({required this.payments});

  factory PaymentsDto.fromJson(Map<String, Object?> json) => _$PaymentsDtoFromJson(json);

  /// Данные платежей
  final List<PaymentDto> payments;

  Map<String, Object?> toJson() => _$PaymentsDtoToJson(this);
}
