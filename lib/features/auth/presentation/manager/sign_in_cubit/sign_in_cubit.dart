// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/domain/use_case/login_use_case.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

var userRole = '';

class SignInCubit extends Cubit<SignInState> {
  final LoginUseCase loginUseCase;
  final _secureStorage = const FlutterSecureStorage();

  SignInCubit(this.loginUseCase) : super(SignInInitial());

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    emit(SignInLoading());
    try {
      var result = await loginUseCase.call(un: username, pw: password);

      result.fold((failure) {
        emit(SignInFailure(failure.message));
      }, (user) async {
        final storedToken = await _secureStorage.read(key: 'jwtToken');
        final storedUsername = await _secureStorage.read(key: 'usernamePublic');

        final storedRoles = await _secureStorage.read(key: 'userRole');
        // Store username and user role in secure storage
        await _secureStorage.write(
            key: 'usernamePublic', value: storedUsername);
        await _secureStorage.write(key: 'userRole', value: storedRoles);
        await _secureStorage.write(
            key: 'jwtToken', value: storedToken); // Store jwtToken if needed

        // Retrieve the stored values for debug or further processing
        final usernamePublic = await _secureStorage.read(key: 'usernamePublic');
        userRole = await _secureStorage.read(key: 'userRole') ?? '';

        emit(SignInSuccess(user));
      });
    } catch (e) {
      emit(SignInFailure("An unexpected error occurred"));
      print("Sign-in error: $e"); // Log the error for debugging
    }
  }
}
