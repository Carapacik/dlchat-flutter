import 'package:dlchat/src/feature/payment/model/payment_method_type.dart';
import 'package:rest_client/subscription/dto/payment_method_data_dto.dart';

class const PaymentMethodData({
  required final PaymentMethodType type,
  required final bool autoCharge,
  final bool? bindCard,
  final String? bindingId,
}) {
  static PaymentMethodDataDto encode(PaymentMethodData method) => PaymentMethodDataDto(
    type: PaymentMethodType.encode(method.type),
    bindCard: method.bindCard,
    bindingId: method.bindingId,
    autocharge: method.autoCharge,
  );
}
