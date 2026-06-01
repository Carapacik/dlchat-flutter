part of 'authentication_bloc.dart';

@Freezed()
sealed class const AuthenticationState._() with _$AuthenticationState {
  const factory idle(User user) = AuthenticationIdle;

  const factory processing(User user) = AuthenticationProcessing;

  // const factory AuthenticationState.success(User user) = AuthenticationSuccess;

  // const factory AuthenticationState.failure(User user) = AuthenticationFailure;

  bool get inProgress => this is AuthenticationProcessing;
}
