import 'package:bloc/bloc.dart';
import 'package:dreamhome_architect/values/strings.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  SigninBloc() : super(SigninInitialState()) {
    on<SigninEvent>((event, emit) async {
      try {
        emit(SigninLoadingState());
        AuthResponse authResponse =
            await Supabase.instance.client.auth.signInWithPassword(
          password: event.password,
          email: event.email,
        );
        if (authResponse.user!.appMetadata['role'] == 'architect') {
          emit(SigninSuccessState());
        } else {
          await Supabase.instance.client.auth.signOut();
          emit(
            SigninFailureState(
              message:
                  'Invalid credentials, please check your username and password and try again',
            ),
          );
        }
      } catch (e, s) {
        Logger().e('$e\n$s');

        if (e is AuthException) {
          emit(SigninFailureState(message: e.message));
        } else {
          emit(SigninFailureState());
        }
      }
    });
  }
}
