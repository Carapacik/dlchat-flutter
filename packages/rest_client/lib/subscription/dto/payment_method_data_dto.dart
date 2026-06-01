import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/subscription/dto/payment_method_type_dto.dart';

part 'payment_method_data_dto.g.dart';

@JsonSerializable()
class const PaymentMethodDataDto({
  /// Тип оплаты
  required final PaymentMethodTypeDto type,

  /// Привязать карту
  required final bool? bindCard,

  /// ID привязки карты
  required final String? bindingId,

  /// Включить автосписание
  required final bool? autocharge,
}) {
  factory fromJson(Map<String, Object?> json) => _$PaymentMethodDataDtoFromJson(json);

  Map<String, Object?> toJson() => _$PaymentMethodDataDtoToJson(this);
}
