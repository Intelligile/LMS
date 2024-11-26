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
    var result = await addPermissionUseCase.call(permissions: permissions);
    result.fold(
      (failure) {
        emit(PermissionStateFailure(errorMessage: failure.message));
      },
      (permissions) {
        emit(AddPermissionStateSuccess());
      },
    );
  }

  Future<void> getPermissions({String? roleName}) async {
    emit(PermissionStateLoading());
    var result = await getPermissionUseCase.call(roleName: roleName);
    result.fold(
      (failure) {
        // Log failure for debugging
        print("Get Permissions Failed: ${failure.message}");
        emit(PermissionStateFailure(errorMessage: failure.message));
      },
      (permissions) {
        if (roleName == null) {
          // Log permissions for debugging
          print("Get All Permissions Success: ${permissions.length} items");
          emit(GetAllPermissionStateSuccess(permissions: permissions));
        } else {
          print(
              "Get Permissions for Role $roleName Success: ${permissions.length} items");
          emit(GetPermissionStateSuccess(permissions: permissions));
        }
      },
    );
  }
}
