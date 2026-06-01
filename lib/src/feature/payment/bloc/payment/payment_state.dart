part of 'payment_bloc.dart';

@Freezed()
sealed class const PaymentState._() with _$PaymentState {
  const factory idle({required String? paymentId}) = PaymentIdle;

  const factory processing({required String? paymentId, @Default(false) bool fromWebView}) = PaymentProcessing;

  const factory successStart(Payment payment, {required String? paymentId}) = PaymentSuccessStart;

  const factory success(Payment payment, {required String? paymentId}) = PaymentSuccess;

  const factory failure({required String? paymentId, required AppException exception}) = PaymentFailure;

  bool get inProgress => this is PaymentProcessing;
}
