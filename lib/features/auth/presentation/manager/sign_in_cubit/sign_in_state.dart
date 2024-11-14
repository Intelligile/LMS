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

// Add this class for DMZ user sign-in state
class SignInDMZUser extends SignInState {
  final dynamic user; // Replace dynamic with your user model type if available
  SignInDMZUser(this.user);
}

class SignInFailure extends SignInState {
  final String error;

  SignInFailure(this.error);
}
