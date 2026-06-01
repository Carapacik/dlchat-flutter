part of 'splash_bloc.dart';

@Freezed()
sealed class const SplashState._() with _$SplashState {
  const factory processing() = SplashProcessing;

  const factory success(Routes route) = SplashSuccess;

  const factory failure(Routes route, {String? latestVersion}) = SplashFailure;
}
