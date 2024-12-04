part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInSuccess extends SignInState {
  // final String jwtToken;
  // final String username;
  // final String roles;

  // SignInSuccess(this.username);
  final Unit unit;

  SignInSuccess(this.unit);
}

class SignInFailure extends SignInState {
  final String error;

  SignInFailure(this.error);
}
