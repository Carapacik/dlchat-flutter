import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'account_client.g.dart';

@RestApi()
abstract class AccountClient {
  factory(Dio dio, {String? baseUrl}) = _AccountClient;

  @DELETE('/v1/accounts')
  Future<void> deleteAccount();
}
