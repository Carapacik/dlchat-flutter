import 'package:flutter/material.dart';
import 'package:rest_client/subscription/dto/payment_method_type_dto.dart';

enum PaymentMethodType() {
  sbp,
  bankCard,
  binding;

  static PaymentMethodType decode(PaymentMethodTypeDto type) =>
      PaymentMethodType.values.firstWhere((e) => e.name == type.name);

  static PaymentMethodTypeDto encode(PaymentMethodType type) =>
      PaymentMethodTypeDto.values.firstWhere((e) => e.name == type.name);

  String localizedText(BuildContext context) => switch (this) {
    PaymentMethodType.sbp => 'Система быстрых платежей',
    PaymentMethodType.bankCard => 'Банковская карта',
    PaymentMethodType.binding => 'Банковская карта',
  };

  static PaymentMethodType fromString(String? value) => PaymentMethodType.values.firstWhere(
    (status) => status.name.toLowerCase() == value?.toLowerCase(),
    orElse: () => PaymentMethodType.bankCard,
  );
}
