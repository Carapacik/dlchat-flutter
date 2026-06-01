part of 'payment_bloc.dart';

@Freezed(copyWith: false)
sealed class PaymentEvent with _$PaymentEvent {
  const factory pay(
    Rate selectedRate,
    UserRate? userRate,
    PaymentMethodData paymentMethod, {
    String? specialOfferId,
    String? promoCode,
    String? email,
  }) = _PaymentPaid;

  const factory updatePaymentStatus({@Default(false) bool fromWebView}) = _PaymentUpdatePaymentStatus;

  const factory cancelPayment() = _PaymentCancel;
}
