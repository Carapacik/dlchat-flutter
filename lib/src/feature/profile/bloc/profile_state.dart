part of 'profile_bloc.dart';

@Freezed()
sealed class const ProfileState._() with _$ProfileState {
  const factory idle(String? phone) = ProfileIdle;

  const factory processing(String? phone) = ProfileProcessing;

  const factory success(String? phone) = ProfileSuccess;

  const factory failure(String? phone, {required AppException exception}) = ProfileFailure;
}
