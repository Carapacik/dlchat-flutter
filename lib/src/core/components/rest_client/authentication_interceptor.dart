import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:retrofit/retrofit.dart';

@immutable
class const InterceptorTokens({required final String access, required final String refresh}) {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterceptorTokens &&
          runtimeType == other.runtimeType &&
          access == other.access &&
          refresh == other.refresh;

  @override
  int get hashCode => access.hashCode ^ refresh.hashCode;
}

class AuthenticationInterceptor<T extends InterceptorTokens>({
  required final Future<T?> Function() getTokens,
  required final Future<void> Function(T data) setTokens,
  required final void Function() expireTokens,
  required final Future<HttpResponse<T?>> Function(Dio dio) refreshTokens,
  final List<String> pathsToRefresh = const [],
  final void Function()? connectionError,
}) extends QueuedInterceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    T? token;
    try {
      token = await getTokens.call();
    } on Object {
      token = null;
    }
    if (token != null) {
      final Map<String, String> headers = _buildAuthHeaders(_useRefresh(options.path) ? token.refresh : token.access);
      options.headers.addAll(headers);
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_hasConnectionError(err)) {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        connectionError?.call();
      }
    }
    if (err.response == null) {
      return handler.next(err);
    }
    if (err.response?.statusCode == 401) {
      try {
        T? token;
        try {
          token = await getTokens.call();
        } on Object {
          token = null;
        }
        if (token == null) {
          throw err;
        }
        final refreshDio = Dio(
          BaseOptions(baseUrl: err.requestOptions.baseUrl, headers: _buildAuthHeaders(token.refresh)),
        );

        // refresh
        final HttpResponse<T?> refreshedToken = await refreshTokens.call(refreshDio);

        if (refreshedToken.response.statusCode == null || refreshedToken.response.statusCode! ~/ 100 != 2) {
          throw DioException(response: refreshedToken.response, requestOptions: refreshedToken.response.requestOptions);
        }

        final T? updatedToken = refreshedToken.data;
        if (updatedToken == null) {
          throw DioException(requestOptions: refreshedToken.response.requestOptions);
        }
        await setTokens.call(updatedToken);
        err.requestOptions.headers.addAll(_buildAuthHeaders(updatedToken.access));
      } on DioException catch (exception) {
        expireTokens.call();
        return handler.reject(exception);
      }

      // retry
      try {
        final retryDio = Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl, headers: err.requestOptions.headers));

        final RequestOptions retriedRequestOptions = err.requestOptions;
        if (retriedRequestOptions.data is FormData) {
          retriedRequestOptions.data = (retriedRequestOptions.data as FormData).clone();
        }
        final Response<dynamic> retriedResponse = await retryDio.fetch<dynamic>(retriedRequestOptions);
        return handler.resolve(retriedResponse);
      } on DioException catch (exception) {
        return handler.reject(exception);
      }
    }
    if (err.response?.statusCode == 403) {
      expireTokens.call();
      return handler.reject(err);
    }
    return handler.next(err);
  }

  bool _hasConnectionError(DioException err) => switch (err.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.connectionError => true,
    _ => false,
  };

  bool _useRefresh(String requestPath) {
    for (final String path in pathsToRefresh) {
      if (requestPath.contains(path)) {
        return true;
      }
    }
    return false;
  }

  Map<String, String> _buildAuthHeaders(String token) => {'Authorization': 'Bearer $token'};
}
