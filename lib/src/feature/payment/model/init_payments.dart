import 'package:rest_client/payment/dto/init_payments_dto.dart';

class const InitPayments({
  required final bool bankCard,
  required final bool sbp,
  required final bool binding,
  required final bool sberbank,
}) {
  factory decode(InitPaymentsDto dto) =>
      InitPayments(bankCard: dto.bankCard, sbp: dto.sbp, binding: dto.binding, sberbank: dto.sberbank);
}
