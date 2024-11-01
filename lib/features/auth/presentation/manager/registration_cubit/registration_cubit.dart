// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:lms/features/auth/domain/use_case/register_use_case.dart';
import 'package:meta/meta.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  RegisterUseCase registerUseCase;
  RegistrationCubit(
    this.registerUseCase,
  ) : super(RegistrationInitial());

  Future<void> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  }) async {
    emit(RegistrationLoading());
    var result = await registerUseCase.call(
      fn: firstName,
      ln: lastName,
      email: email,
      pw: password,
      un: username,
      phone: phone,
    );
    result.fold(
      (failure) {
        print(failure.message);
        emit(RegistrationFailure(errorMessage: failure.message));
      },
      (result) {
        emit(RegistrationSuccess());
      },
    );
  }
}
