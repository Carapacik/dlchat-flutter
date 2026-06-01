part of 'otp_code_bloc.dart';

@Freezed()
sealed class const OtpCodeState._() with _$OtpCodeState {
  const factory idle() = OtpCodeIdle;

  const factory processing() = OtpCodeProcessing;

  const factory success() = OtpCodeSuccess;

  const factory failure({required AppException exception}) = OtpCodeFailure;

  bool get inProgress => this is OtpCodeProcessing;
}
