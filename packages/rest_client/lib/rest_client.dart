import 'package:dio/dio.dart';
import 'package:rest_client/account/account_client.dart';
import 'package:rest_client/auth/auth_client.dart';
import 'package:rest_client/chat/chat_client.dart';
import 'package:rest_client/chat_v2/chat_v2_client.dart';
import 'package:rest_client/file/file_client.dart';
import 'package:rest_client/metrics/metrics_client.dart';
import 'package:rest_client/payment/payment_client.dart';
import 'package:rest_client/state/state_client.dart';
import 'package:rest_client/subscription/subscription_client.dart';
import 'package:rest_client/telegram/telegram_client.dart';
import 'package:rest_client/transcriptions/transcriptions_client.dart';

final class RestClient({required final Dio _dio, required final String _baseUrl}) {
  AuthClient? _authClient;
  AccountClient? _accountClient;
  ChatClient? _chatClient;
  ChatV2Client? _chatV2Client;
  MetricsClient? _metricsClient;
  PaymentClient? _paymentClient;
  SendFileClient? _sendFileClient;
  StateClient? _stateClient;
  SubscriptionClient? _subscriptionClient;
  TelegramClient? _telegramClient;
  TranscriptionsClient? _transcriptionsClient;

  AuthClient get authClient => _authClient ??= AuthClient(_dio, baseUrl: _baseUrl);

  AccountClient get accountClient => _accountClient ??= AccountClient(_dio, baseUrl: _baseUrl);

  ChatClient get chatClient => _chatClient ??= ChatClient(_dio, baseUrl: _baseUrl);

  ChatV2Client get chatV2Client => _chatV2Client ??= ChatV2Client(_dio, baseUrl: _baseUrl);

  MetricsClient get metricsClient => _metricsClient ??= MetricsClient(_dio, baseUrl: _baseUrl);

  PaymentClient get paymentClient => _paymentClient ??= PaymentClient(_dio, baseUrl: _baseUrl);

  SendFileClient get sendFileClient => _sendFileClient ??= SendFileClient(_dio, baseUrl: _baseUrl);

  StateClient get stateClient => _stateClient ??= StateClient(_dio, baseUrl: _baseUrl);

  SubscriptionClient get subscriptionClient => _subscriptionClient ??= SubscriptionClient(_dio, baseUrl: _baseUrl);

  TelegramClient get telegramClient => _telegramClient ??= TelegramClient(_dio, baseUrl: _baseUrl);

  TranscriptionsClient get transcriptionsClient =>
      _transcriptionsClient ??= TranscriptionsClient(_dio, baseUrl: _baseUrl);
}
