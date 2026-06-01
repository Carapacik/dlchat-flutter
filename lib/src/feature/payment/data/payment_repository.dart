import 'package:dlchat/src/feature/payment/model/binding_card.dart';
import 'package:dlchat/src/feature/payment/model/payment_method_data.dart';
import 'package:dlchat/src/feature/payment/model/payment_model.dart';
import 'package:dlchat/src/feature/payment/model/promo_code.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/model/remaining.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:rest_client/payment/payment_client.dart';
import 'package:rest_client/subscription/dto/activate_license_command.dart';
import 'package:rest_client/subscription/dto/pay_rate_command.dart';
import 'package:rest_client/subscription/dto/verify_promo_code_command.dart';
import 'package:rest_client/subscription/subscription_client.dart';

abstract interface class IPaymentRepository() {
  Future<List<BindingCard>> getBindingCards();

  Future<void> deleteBingingCard(String bindingId);

  Future<List<Rate>> getRates();

  Future<List<UserRate>> getFrozenSubscriptions();

  Future<UserRate> getCurrentSubscription();

  Future<Payment> getPayment(String paymentId);

  Future<String> pay({
    required PaymentMethodData paymentMethod,
    required String rateId,
    String? email,
    String? specialOfferId,
    String? promoCode,
  });

  Future<String> prolong({
    required PaymentMethodData paymentMethod,
    required String rateId,
    String? email,
    String? specialOfferId,
    String? promoCode,
  });

  Future<String> upgrade({
    required PaymentMethodData paymentMethod,
    required String rateId,
    String? email,
    String? specialOfferId,
    String? promoCode,
  });

  Future<void> cancelPayment();

  Future<PromoCodeOrLicense> verifyPromoCode(String code);

  Future<void> activateLicense(String code);

  Future<RemainingRequests> getUserRemaining();
}

class const PaymentRepository({
  required final PaymentClient _paymentClient,
  required final SubscriptionClient _subscriptionClient,
}) implements IPaymentRepository {
  @override
  Future<List<BindingCard>> getBindingCards() =>
      _paymentClient.getBindings().then((d) => d.result.bindings.map(BindingCard.decode).toList());

  @override
  Future<void> deleteBingingCard(String bindingId) => _paymentClient.deleteBinding(bindingId: bindingId);

  @override
  Future<List<Rate>> getRates() =>
      _subscriptionClient.getRates().then((dto) => dto.result.rates.map(Rate.decode).toList());

  @override
  Future<List<UserRate>> getFrozenSubscriptions() => _subscriptionClient
      .getUserRate(status: 'FROZEN')
      .then((dto) => dto.result.subscriptions.map(UserRate.decode).toList());

  @override
  Future<UserRate> getCurrentSubscription() =>
      _subscriptionClient.getUserCurrentSubscription().then((dto) => UserRate.decode(dto.result));

  @override
  Future<Payment> getPayment(String paymentId) =>
      _subscriptionClient.getPayment(paymentId: paymentId).then((dto) => Payment.decode(dto.result));

  @override
  Future<String> pay({
    required PaymentMethodData paymentMethod,
    required String rateId,
    String? email,
    String? specialOfferId,
    String? promoCode,
  }) => _subscriptionClient
      .pay(
        body: PayRateCommand(
          paymentMethod: PaymentMethodData.encode(paymentMethod),
          rateId: rateId,
          email: email,
          specialOfferId: specialOfferId,
          promoCode: promoCode,
        ),
      )
      .then((dto) => dto.result.id);

  @override
  Future<String> prolong({
    required PaymentMethodData paymentMethod,
    required String rateId,
    String? email,
    String? specialOfferId,
    String? promoCode,
  }) => _subscriptionClient
      .prolong(
        body: PayRateCommand(
          paymentMethod: PaymentMethodData.encode(paymentMethod),
          rateId: rateId,
          email: email,
          specialOfferId: specialOfferId,
          promoCode: promoCode,
        ),
      )
      .then((dto) => dto.result.id);

  @override
  Future<String> upgrade({
    required PaymentMethodData paymentMethod,
    required String rateId,
    String? email,
    String? specialOfferId,
    String? promoCode,
  }) => _subscriptionClient
      .upgrade(
        body: PayRateCommand(
          paymentMethod: PaymentMethodData.encode(paymentMethod),
          rateId: rateId,
          email: email,
          specialOfferId: specialOfferId,
          promoCode: promoCode,
        ),
      )
      .then((dto) => dto.result.id);

  @override
  Future<void> cancelPayment() => _subscriptionClient.cancelPayment();

  @override
  Future<PromoCodeOrLicense> verifyPromoCode(String code) => _subscriptionClient
      .verifyPromoCode(body: VerifyPromoCodeCommand(promoCode: code))
      .then((dto) => PromoCodeOrLicense.decode(dto.result.promoCode));

  @override
  Future<void> activateLicense(String code) =>
      _subscriptionClient.activateLicense(body: ActivateLicenseCommand(license: code));

  @override
  Future<RemainingRequests> getUserRemaining() =>
      _subscriptionClient.getUserRemainingRequest().then((dto) => RemainingRequests.decode(dto.result));
}
