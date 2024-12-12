import 'package:bloc/bloc.dart';
import 'package:lms/features/roles_and_premission/data/models/permission.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/add_permission_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/permission_use_case/get_permission_use_case.dart';
import 'package:meta/meta.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit(this.addPermissionUseCase, this.getPermissionUseCase)
      : super(PermissionInitial());
  final AddPermissionUseCase addPermissionUseCase;
  final GetPermissionUseCase getPermissionUseCase;

  Future<void> addPermission(List<Permission> permissions) async {
    emit(PermissionStateLoading());
    print(
        "Attempting to add permissions: ${permissions.map((perm) => perm.toJson()).toList()}");
    var result = await addPermissionUseCase.call(permissions: permissions);
    result.fold(
      (failure) {
        print("Failed to add permissions: ${failure.message}");
        emit(PermissionStateFailure(errorMessage: failure.message));
      },
      (permissions) {
        print("Successfully added permissions");
        emit(AddPermissionStateSuccess());
      },
    );
  }

  Future<void> getPermissions({String? roleName}) async {
    emit(PermissionStateLoading());
    print("Fetching permissions for role: $roleName");

    try {
      var result = await getPermissionUseCase.call(roleName: roleName);
      result.fold(
        (failure) {
          print("Get Permissions Failed: ${failure.message}");
          emit(PermissionStateFailure(errorMessage: failure.message));
        },
        (permissions) {
          print("Permissions fetched");
          if (permissions.isEmpty) {
            print("No permissions available");
          }

          if (roleName == null) {
            emit(GetAllPermissionStateSuccess(permissions: permissions));
          } else {
            emit(GetPermissionStateSuccess(permissions: permissions));
          }
        },
      );
    } catch (e) {
      print("Unexpected error: $e");
      emit(PermissionStateFailure(errorMessage: e.toString()));
    }
  }

  bool hasPermission(String permissionName, List<Permission> permissions) {
    print(
        "Checking if permission '$permissionName' exists in: ${permissions.map((perm) => perm.permission).toList()}");
    return permissions.any((perm) => perm.permission == permissionName);
  }
}
