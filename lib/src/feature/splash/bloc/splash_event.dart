part of 'splash_bloc.dart';

@Freezed(copyWith: false)
sealed class SplashEvent with _$SplashEvent {
  const factory start() = _SplashStarted;
}
