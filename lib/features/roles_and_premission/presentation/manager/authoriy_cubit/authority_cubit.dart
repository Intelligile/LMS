import 'package:bloc/bloc.dart';
import 'package:lms/features/roles_and_premission/data/models/authority.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/add_authorities_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/delete_authority_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/get_authorities_use_case.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/authority_use_case/update_authority_permissions_use_case.dart';
import 'package:meta/meta.dart';

part 'authority_state.dart';

class AuthorityCubit extends Cubit<AuthorityState> {
  AuthorityCubit(this.addAuthoritiesUseCase, this.getAuthoritiesUseCase,
      this.updateAuthorityPermissionsUseCase, this.deleteAuthorityUseCase)
      : super(AuthorityStateInitial());
  final AddAuthoritiesUseCase addAuthoritiesUseCase;
  final GetAuthoritiesUseCase getAuthoritiesUseCase;
  final UpdateAuthorityPermissionsUseCase updateAuthorityPermissionsUseCase;
  final DeleteAuthorityUseCase deleteAuthorityUseCase;
  Future<void> addAuthorities(List<Authority> authorities) async {
    emit(AuthorityStateLoading());
    var result = await addAuthoritiesUseCase.call(authorities: authorities);
    result.fold(
      (failure) {
        emit(AuthorityStateFailure(errorMessage: failure.message));
      },
      (authorities) {
        emit(AddAuthorityStateSuccess());
      },
    );
  }

  Future<void> deleteAuthority({required int authorityId}) async {
    emit(DeleteAuthorityStateLoading());
    var result = await deleteAuthorityUseCase.call(authorityId: authorityId);
    result.fold(
      (failure) {
        emit(DeleteAuthorityStateFailure(errorMessage: failure.message));
      },
      (unit) {
        emit(DeleteAuthorityStateSuccess());
      },
    );
  }

  Future<void> updateAuthorityPermissions(
      {dynamic authorityId, required List<dynamic> authorities}) async {
    emit(UpdateAuthorityPermissionsStateLoading());
    var result = await updateAuthorityPermissionsUseCase.call(
        authorityId: authorityId, newAuthorities: authorities);
    result.fold(
      (failure) {
        emit(UpdateAuthorityPermissionsStateFailure(
            errorMessage: failure.message));
      },
      (Unit) {
        emit(UpdateAuthorityPermissionsStateSuccess());
      },
    );
  }

  Future<void> getAuthorities() async {
    emit(AuthorityStateLoading());
    var result = await getAuthoritiesUseCase.call();
    result.fold(
      (failure) {
        emit(AuthorityStateFailure(errorMessage: failure.message));
      },
      (authorities) {
        emit(GetAuthorityStateSuccess(authorities: authorities));
      },
    );
  }
}
