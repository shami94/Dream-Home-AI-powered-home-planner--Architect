import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpEvent>((event, emit) async {
      try {
        emit(SignUpLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;
        if (event is SignUpUserEvent) {
          await supabaseClient.auth.signUp(
            email: event.email,
            password: event.password,
          );

          emit(SignUpSuccessState());
        } else if (event is InsertUserDataEvent) {
          event.userDetails['user_id'] = supabaseClient.auth.currentUser!.id;
          event.userDetails['photo'] = await uploadFile(
            'architects/photo',
            event.userDetails['photo_file'],
            event.userDetails['photo_name'],
          );
          event.userDetails.remove('photo_file');
          event.userDetails.remove('photo_name');

          event.userDetails['license_url'] = await uploadFile(
            'architects/license',
            event.userDetails['license_file'],
            event.userDetails['license_name'],
          );
          event.userDetails.remove('license_file');
          event.userDetails.remove('license_name');

          await supabaseClient.from('architects').insert(event.userDetails);

          emit(SignUpSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        if (e is AuthException) {
          emit(SignUpFailureState(message: e.message));
        } else {
          emit(SignUpFailureState());
        }
      }
    });
  }
}
