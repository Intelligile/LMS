part of 'registration_cubit.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {}

// Additional State for Unverified Users
class RegistrationUnverified extends RegistrationState {
  final String username;
  final String message;

  RegistrationUnverified({
    required this.username,
    required this.message,
  });
}

class RegistrationFailure extends RegistrationState {
  final String errorMessage;

  RegistrationFailure({required this.errorMessage});
}
