import 'package:dio/dio.dart';
import 'package:dlchat/src/core/exception/app_exception.dart';
import 'package:dlchat/src/core/exception/network_exception_type.dart';

export 'app_exception.dart';
export 'network_exception_type.dart';

class ExceptionHandler() {
  static Future<void> handle(
    Future<void> Function() handler, {
    void Function(AppException exception, StackTrace stackTrace)? onError,
    void Function()? onDone,
  }) async {
    try {
      await handler.call();
    } on DioException catch (exception, stackTrace) {
      final Object? responseData = exception.response?.data;
      String? responseMessage;
      // Specify your response message
      if (responseData is Map<String, Object?>) {
        responseMessage = responseData['message']?.toString();
      }
      final bool isConnectionError = switch (exception.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.connectionError => true,
        _ => false,
      };
      final appException = AppException.network(
        responseMessage ?? (isConnectionError ? 'Ошибка подключения' : exception.error.toString()),
        statusCode: exception.response?.statusCode,
        responseData: exception.response?.data,
        networkType: NetworkExceptionType.byStatusCode(exception),
      );
      onError?.call(appException, stackTrace);
      Error.throwWithStackTrace(appException, stackTrace);
    } on AppException catch (exception, stackTrace) {
      final appException = AppException.unknown(exception.message);
      onError?.call(appException, stackTrace);
      Error.throwWithStackTrace(AppException.unknown(exception.message), stackTrace);
    } on Object catch (exception, stackTrace) {
      final appException = AppException.unknown(exception.toString());
      onError?.call(appException, stackTrace);
      Error.throwWithStackTrace(AppException.unknown(exception.toString()), stackTrace);
    } finally {
      onDone?.call();
    }
  }
}
