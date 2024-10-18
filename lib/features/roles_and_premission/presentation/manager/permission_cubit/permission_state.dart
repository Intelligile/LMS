part of 'permission_cubit.dart';

@immutable
sealed class PermissionState {}

final class PermissionInitial extends PermissionState {}

final class PermissionStateLoading extends PermissionState {}

final class AddPermissionStateSuccess extends PermissionState {}

final class GetPermissionStateSuccess extends PermissionState {
  final List<Permission> permissions;

  GetPermissionStateSuccess({required this.permissions});
}

final class GetAllPermissionStateSuccess extends PermissionState {
  final List<Permission> permissions;

  GetAllPermissionStateSuccess({required this.permissions});
}

final class PermissionStateFailure extends PermissionState {
  final String errorMessage;

  PermissionStateFailure({required this.errorMessage});
}
