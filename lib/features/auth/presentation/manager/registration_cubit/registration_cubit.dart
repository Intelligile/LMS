// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/core/errors/failure.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/domain/use_case/login_use_case.dart';
import 'package:lms/features/auth/domain/use_case/register_use_case.dart';
import 'package:lms/features/auth/presentation/manager/sign_in_cubit/sign_in_cubit.dart';
import 'package:meta/meta.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final RegisterUseCase registerUseCase;
  final AuthRemoteDataSource authRemoteDataSource;
  final LoginUseCase loginUseCase; // Properly include LoginUseCase
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  RegistrationCubit(
    this.registerUseCase,
    this.authRemoteDataSource,
    this.loginUseCase,
  ) : super(RegistrationInitial());

  Future<void> register({
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String accountName,
    required String departmentName,
    required String legalEntityName,
    required String globalEntityName,
    required String website,
    required String legalContactName,
    required String legalContactEmail,
    required String legalContactNumber,
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
        accountName: accountName,
        departmentName: departmentName,
        legalEntityName: legalEntityName,
        globalEntityName: globalEntityName,
        website: website,
        legalContactName: legalContactName,
        legalContactEmail: legalContactEmail,
        legalContactNumber: legalContactNumber,
      );

      result.fold(
        (failure) => _handleFailure(failure),
        (_) async {
          // Registration successful, now log the user in
          try {
            final loginResult = await loginUseCase.call(
              un: username,
              pw: password,
            );

            loginResult.fold(
              (failure) {
                print("Login failed: ${failure.message}");
                throw Exception("Login failed after registration.");
              },
              (_) async {
                // Store login data in secure storage
                final loginData = await authRemoteDataSource.loginUser(
                  username: username,
                  password: password,
                ); // Ensure Remote Call Returns the Login Data

                if (loginData.containsKey('jwtToken')) {
                  await secureStorage.write(
                      key: 'jwtToken', value: loginData['jwtToken'].toString());
                  await secureStorage.write(
                      key: 'usernamePublic',
                      value: loginData['username'].toString());
                  await secureStorage.write(
                      key: 'userRole', value: loginData['roles'].toString());
                  await secureStorage.write(
                      key: 'organizationId',
                      value: loginData['organizationId'].toString());

                  // Parse organizationId when retrieving
                  organizationId = int.tryParse(
                          await secureStorage.read(key: 'organizationId') ??
                              '0') ??
                      0;
                  if (loginData.containsKey('exp')) {
                    await secureStorage.write(
                        key: 'tokenExpiration',
                        value: loginData['exp'].toString());
                    print("Saved token expiration: ${loginData['exp']}");
                  } else {
                    print(
                        "Token expiration (exp) not found in login response.");
                  }

                  print("Login result: $loginData");

                  emit(RegistrationSuccess());
                } else {
                  throw Exception('Login failed after registration.');
                }
              },
            );
          } catch (e) {
            print("Error during login: $e");
            emit(RegistrationFailure(
                errorMessage: 'Registration succeeded, but login failed: $e'));
          }
        },
      );
    } catch (e) {
      print("Error during registration: $e");
      emit(RegistrationFailure(errorMessage: e.toString()));
    }
  }

  void _handleFailure(Failure failure) {
    print("Registration failed: ${failure.message}");
    emit(RegistrationFailure(errorMessage: failure.message));
  }

  Future<void> clearStorage() async {
    await secureStorage.deleteAll();
  }
}
