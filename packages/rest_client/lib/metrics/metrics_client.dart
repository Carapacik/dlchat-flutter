import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'metrics_client.g.dart';

@RestApi()
abstract class MetricsClient {
  factory(Dio dio, {String? baseUrl}) = _MetricsClient;

  @POST('/v1/metrics/')
  Future<void> sendEvent({@Field('eventName') required String eventName, @Field('eventJson') String? eventJson});
}
