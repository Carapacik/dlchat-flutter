import 'package:meta/meta.dart';

/// {@template user}
/// The user entry model.
/// {@endtemplate}
@immutable
sealed class const User._() with _UserPatternMatching, _UserShortcuts {
  /// {@macro user}
  this;

  /// {@macro user}
  @literal
  const factory unauthenticated() = UnauthenticatedUser;

  /// {@macro user}
  const factory authenticated({required String accessToken, required String refreshToken}) = AuthenticatedUser;

  /// {@macro user}
  factory fromJson(Map<String, Object?> json) {
    if (json case <String, Object?>{
      'accessToken': final String accessToken,
      'refreshToken': final String refreshToken,
    }) {
      return AuthenticatedUser(accessToken: accessToken, refreshToken: refreshToken);
    }
    return const UnauthenticatedUser();
  }

  /// The user's accessToken.
  abstract final String? accessToken;
  abstract final String? refreshToken;

  Map<String, Object?> toJson();
}

/// {@macro user}
///
/// Unauthenticated user.
class const UnauthenticatedUser() extends User {
  /// {@macro user}
  this : super._();

  /// {@macro user}
  // ignore: avoid_unused_constructor_parameters
  factory fromJson(Map<String, Object?> json) => const UnauthenticatedUser();

  @override
  String? get accessToken => null;

  @override
  String? get refreshToken => null;

  @override
  bool get isAuthenticated => false;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'user',
    'status': 'unauthenticated',
    'authenticated': false,
    'accessToken': null,
    'refreshToken': null,
  };

  @override
  T map<T>({
    required T Function(UnauthenticatedUser user) unauthenticated,
    required T Function(AuthenticatedUser user) authenticated,
  }) => unauthenticated(this);

  @override
  User copyWith({String? accessToken, String? refreshToken}) => accessToken != null && refreshToken != null
      ? AuthenticatedUser(accessToken: accessToken, refreshToken: refreshToken)
      : const UnauthenticatedUser();

  @override
  int get hashCode => -1;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnauthenticatedUser && accessToken == other.accessToken ||
      other is UnauthenticatedUser && refreshToken == other.refreshToken;

  @override
  String toString() => 'UnauthenticatedUser';
}

/// {@macro user}
final class const AuthenticatedUser({
  @override @nonVirtual required final String accessToken,
  @override @nonVirtual required final String refreshToken,
}) extends User {
  /// {@macro user}
  this : super._();

  /// {@macro user}
  factory fromJson(Map<String, Object?> json) {
    if (json.isEmpty) {
      throw FormatException('Json is empty', json);
    }
    if (json case <String, Object?>{
      'accessToken': final String accessToken,
      'refreshToken': final String refreshToken,
    }) {
      return AuthenticatedUser(accessToken: accessToken, refreshToken: refreshToken);
    }
    throw FormatException('InvalaccessToken json format', json);
  }

  @override
  @nonVirtual
  bool get isAuthenticated => true;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
    'type': 'user',
    'status': 'authenticated',
    'authenticated': true,
    'accessToken': accessToken,
    'refreshToken': refreshToken,
  };

  @override
  T map<T>({
    required T Function(UnauthenticatedUser user) unauthenticated,
    required T Function(AuthenticatedUser user) authenticated,
  }) => authenticated(this);

  @override
  AuthenticatedUser copyWith({String? accessToken, String? refreshToken}) =>
      AuthenticatedUser(accessToken: accessToken ?? this.accessToken, refreshToken: refreshToken ?? this.refreshToken);

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthenticatedUser && accessToken == other.accessToken ||
      other is AuthenticatedUser && refreshToken == other.refreshToken;

  @override
  String toString() => 'AuthenticatedUser(accessToken: $accessToken, refreshToken: $refreshToken)';
}

mixin _UserPatternMatching {
  /// Pattern matching on [User] subclasses.
  T map<T>({
    required T Function(UnauthenticatedUser user) unauthenticated,
    required T Function(AuthenticatedUser user) authenticated,
  });

  /// Pattern matching on [User] subclasses.
  T maybeMap<T>({
    required T Function() orElse,
    T Function(UnauthenticatedUser user)? unauthenticated,
    T Function(AuthenticatedUser user)? authenticated,
  }) => map<T>(
    unauthenticated: (user) => unauthenticated?.call(user) ?? orElse(),
    authenticated: (user) => authenticated?.call(user) ?? orElse(),
  );

  /// Pattern matching on [User] subclasses.
  T? mapOrNull<T>({
    T Function(UnauthenticatedUser user)? unauthenticated,
    T Function(AuthenticatedUser user)? authenticated,
  }) => map<T?>(
    unauthenticated: (user) => unauthenticated?.call(user),
    authenticated: (user) => authenticated?.call(user),
  );
}

mixin _UserShortcuts on _UserPatternMatching {
  /// User is authenticated.
  bool get isAuthenticated;

  /// User is not authenticated.
  bool get isNotAuthenticated => !isAuthenticated;

  /// Copy with new values.
  User copyWith({String? accessToken, String? refreshToken});
}
