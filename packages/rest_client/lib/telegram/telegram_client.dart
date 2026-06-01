// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:rest_client/telegram/dto/generate_otp_command.dart';
import 'package:rest_client/telegram/dto/verify_telegram_command.dart';
import 'package:retrofit/retrofit.dart';

part 'telegram_client.g.dart';

@RestApi()
abstract class TelegramClient {
  factory TelegramClient(Dio dio, {String? baseUrl}) = _TelegramClient;

  /// Generate Otp Code Telegram
  @POST('/v1/accounts/users/telegram/OTP')
  Future<void> generateOtpCodeTelegram({@Body() required GenerateOtpCommand body});

  /// Verify Telegram
  @POST('/v1/accounts/users/telegram/verify')
  Future<void> verifyTelegram({@Body() required VerifyTelegramCommand body});
}
