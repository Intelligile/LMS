part of 'user_dto_cubit.dart';

@immutable
sealed class UserDtoState {}

final class UserDtoInitial extends UserDtoState {}

final class FetchUserLoadingState extends UserDtoState {}

final class FetchUserSuccessState extends UserDtoState {
  final List<UserDto> users;

  FetchUserSuccessState({required this.users});
}

final class FetchUserFailureState extends UserDtoState {
  final String errorMessage;

  FetchUserFailureState({required this.errorMessage});
}
