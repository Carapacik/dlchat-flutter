import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/authentication/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_bloc.freezed.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

final class AuthenticationBloc({
  required final IAuthenticationRepository _authenticationRepository,
  required AuthenticationState initialState,
}) extends Bloc<AuthenticationEvent, AuthenticationState> {
  this : super(initialState) {
    _userSubscription = _authenticationRepository.userChanges().listen((user) {
      add(AuthenticationEvent.userListen(user));
    });
    on<AuthenticationEvent>(
      (event, emit) async => switch (event) {
        final _AuthenticationUserListen e => _userListen(e, emit),
        final _AuthenticationSignOutPressed e => _singOutPressed(e, emit),
      },
    );
  }

  late final StreamSubscription<User> _userSubscription;

  @override
  Future<void> close() async {
    await _userSubscription.cancel();
    return await super.close();
  }

  void _userListen(_AuthenticationUserListen event, Emitter<AuthenticationState> emitter) =>
      emitter(AuthenticationState.idle(event.user));

  Future<void> _singOutPressed(_AuthenticationSignOutPressed event, Emitter<AuthenticationState> emitter) =>
      _authenticationRepository.signOut();
}
