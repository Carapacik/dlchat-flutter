import 'package:dlchat/src/core/exception/network_exception_type.dart';
import 'package:meta/meta.dart';

@immutable
sealed class const AppException._() with _AppExceptionPatternMatching, _AppExceptionShortcuts implements Exception {
  const factory network(String message, {NetworkExceptionType? networkType, int? statusCode, Object? responseData}) =
      NetworkException;

  const factory unknown(String message) = UnknownException;

  abstract final String message;
  abstract final NetworkExceptionType? networkType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppException && runtimeType == other.runtimeType && message == other.message;

  @override
  int get hashCode => message.hashCode;
}

@immutable
final class const NetworkException(
  @override final String message, {
  final int? statusCode,
  final Object? responseData,
  @override final NetworkExceptionType? networkType,
}) extends AppException {
  this : super._();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkException &&
          runtimeType == other.runtimeType &&
          statusCode == other.statusCode &&
          responseData == other.responseData &&
          networkType == other.networkType;

  @override
  int get hashCode => statusCode.hashCode ^ responseData.hashCode ^ networkType.hashCode;

  @override
  String toString() =>
      'AppException.network($message, statusCode: $statusCode, code: ${networkType?.code}, responseData: $responseData)';

  @override
  bool get isNetwork => true;

  @override
  T map<T>({required T Function(NetworkException e) network, required T Function(UnknownException e) unknown}) =>
      network.call(this);
}

@immutable
final class const UnknownException(@override final String message) extends AppException {
  this : super._();

  @override
  NetworkExceptionType? get networkType => null;

  @override
  bool get isNetwork => false;

  @override
  T map<T>({required T Function(NetworkException e) network, required T Function(UnknownException e) unknown}) =>
      unknown.call(this);

  @override
  String toString() => 'AppException.unknown($message)';
}

mixin _AppExceptionPatternMatching {
  T map<T>({required T Function(NetworkException e) network, required T Function(UnknownException e) unknown});

  T maybeMap<T>({
    required T Function() orElse,
    T Function(NetworkException e)? network,
    T Function(UnknownException e)? unknown,
  }) => map<T>(network: (e) => network?.call(e) ?? orElse(), unknown: (e) => unknown?.call(e) ?? orElse());

  T? mapOrNull<T>({T Function(NetworkException e)? network, T Function(UnknownException e)? unknown}) =>
      map<T?>(network: (e) => network?.call(e), unknown: (e) => unknown?.call(e));
}

mixin _AppExceptionShortcuts on _AppExceptionPatternMatching {
  bool get isNetwork;
}
