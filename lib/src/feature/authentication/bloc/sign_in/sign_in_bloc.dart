import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/authentication/model/input_phone_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_bloc.freezed.dart';
part 'sign_in_event.dart';
part 'sign_in_state.dart';

final class SignInBloc({required final IAuthenticationRepository _authenticationRepository})
    extends Bloc<SignInEvent, SignInState> {
  this : super(const SignInState.idle()) {
    on<_SignInPhoneSent>(_sendPhone);
  }

  Future<void> _sendPhone(_SignInPhoneSent event, Emitter<SignInState> emitter) async {
    emitter(const SignInState.processing());
    await ExceptionHandler.handle(
      () async {
        await _authenticationRepository.initPhone(event.phone, event.type);
        emitter(SignInState.success(event.phone));
      },
      onError: (exception, stackTrace) => emitter(SignInState.failure(exception: exception)),
      onDone: () => emitter(const SignInState.idle()),
    );
  }
}
