part of 'sign_up_bloc.dart';

@immutable
sealed class SignUpEvent {}

class SignUpUserEvent extends SignUpEvent {
  final String email, password;

  SignUpUserEvent({
    required this.email,
    required this.password,
  });
}

class InsertUserDataEvent extends SignUpEvent {
  final Map userDetails;

  InsertUserDataEvent({
    required this.userDetails,
  });
}
