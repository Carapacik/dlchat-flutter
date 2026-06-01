import 'package:dlchat/src/feature/payment/model/payment_method_type.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/subscription/dto/payment_dto.dart';
import 'package:rest_client/subscription/dto/payment_state.dart';

@immutable
class const Payment({
  /// Идентификатор платежа
  required final String id,

  /// Сумма платежа (в минимальных единицах валюты)
  required final int amount,

  /// Тип платежа
  required final PaymentMethodType method,

  /// Состояние платежа
  required final PaymentStatus status,

  /// Дата создания платежа
  required final DateTime createdAt,

  /// Ссылка на платеж
  final String? url,
}) {
  factory decode(PaymentDto input) => Payment(
    id: input.id,
    amount: input.amount,
    method: PaymentMethodType.decode(input.method),
    status: PaymentStatus.decode(input.state),
    url: input.url,
    createdAt: input.createdAt,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Payment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          method == other.method &&
          status == other.status &&
          createdAt == other.createdAt &&
          url == other.url;

  @override
  int get hashCode =>
      id.hashCode ^ amount.hashCode ^ method.hashCode ^ status.hashCode ^ createdAt.hashCode ^ url.hashCode;
}

enum PaymentStatus(final String json) {
  created('CREATED'),
  inProgress('IN_PROGRESS'),
  succeeded('SUCCEEDED'),
  failed('FAILED');

  factory decode(PaymentStateDto dto) => PaymentStatus.values.firstWhere((e) => e.json == dto.json);
}
