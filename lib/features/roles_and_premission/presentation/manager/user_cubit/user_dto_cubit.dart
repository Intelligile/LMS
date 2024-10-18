// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:lms/features/roles_and_premission/data/models/user_dto.dart';
import 'package:lms/features/roles_and_premission/domain/use_case/user_use_case.dart';
import 'package:meta/meta.dart';

part 'user_dto_state.dart';

class UserDtoCubit extends Cubit<UserDtoState> {
  FetchUsersUseCase fetchUsersUseCase;
  UserDtoCubit(
    this.fetchUsersUseCase,
  ) : super(UserDtoInitial());
  Future<void> getUsers({dynamic roleId}) async {
    emit(FetchUserLoadingState());
    var result = await fetchUsersUseCase.call(roleId: roleId);
    result.fold(
      (failure) {
        emit(FetchUserFailureState(errorMessage: failure.message));
      },
      (users) {
        emit(FetchUserSuccessState(users: users));
      },
    );
  }
}
