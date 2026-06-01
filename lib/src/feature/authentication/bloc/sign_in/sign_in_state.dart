part of 'sign_in_bloc.dart';

@Freezed()
sealed class const SignInState._() with _$SignInState {
  const factory idle() = SignInIdle;

  const factory processing() = SignInProcessing;

  const factory success(String phone) = SignInSuccess;

  const factory failure({required AppException exception}) = SignInFailure;

  bool get inProgress => this is SignInProcessing;
}
