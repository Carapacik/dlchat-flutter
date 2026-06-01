import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

final class ProfileBloc({required final IUserRepository _userRepository}) extends Bloc<ProfileEvent, ProfileState> {
  this : super(const ProfileState.processing(null)) {
    on<ProfileEvent>(
      (event, emit) async => await switch (event) {
        final _ProfileStarted e => _start(e, emit),
        final _ProfileAccountDeleted e => _deleteAccount(e, emit),
      },
    );

    add(const ProfileEvent.start());
  }

  Future<void> _start(_ProfileStarted event, Emitter<ProfileState> emitter) async {
    final String? phone = await _userRepository.phone;
    final String prettyPhoneNumber = formatAsPhoneNumber(phone ?? '') ?? '';
    emitter(ProfileState.idle(prettyPhoneNumber));
  }

  Future<void> _deleteAccount(_ProfileAccountDeleted event, Emitter<ProfileState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _userRepository.deleteAccount();
      },
      onError: (exception, stackTrace) => emitter(ProfileState.failure(state.phone, exception: exception)),
      onDone: () => emitter(ProfileState.idle(state.phone)),
    );
  }
}
