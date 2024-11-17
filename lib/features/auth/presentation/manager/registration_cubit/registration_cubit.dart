// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/auth/domain/use_case/register_use_case.dart';
import 'package:meta/meta.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegisterUseCase registerUseCase;

  RegistrationCubit(this.registerUseCase) : super(RegistrationInitial());

  Future<void> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String organizationName,
    required String organizationCountry,
    required String organizationAddress,
    required String organizationContactEmail,
    required String organizationContactPhone,
  }) async {
    emit(RegistrationLoading());

    try {
      final result = await registerUseCase.call(
        fn: firstName,
        ln: lastName,
        email: email,
        pw: password,
        un: username,
        phone: phone,
        organizationName: organizationName,
        organizationCountry: organizationCountry,
        organizationAddress: organizationAddress,
        organizationContactEmail: organizationContactEmail,
        organizationContactPhone: organizationContactPhone,
      );

      result.fold(
        (failure) {
          _handleFailure(failure);
        },
        (_) {
          emit(RegistrationSuccess());
        },
      );
    } catch (e) {
      emit(RegistrationFailure(errorMessage: e.toString()));
    }
  }

  void _handleFailure(Failure failure) {
    print("Registration failed: ${failure.message}");
    emit(RegistrationFailure(errorMessage: failure.message));
  }
}
