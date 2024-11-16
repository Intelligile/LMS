// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:lms/features/auth/domain/use_case/login_use_case.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

var userRole = '';
var organizationId = '';
var isDMZAccount = false;

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
        // Store username and user role in secure storage for standard users
        await _secureStorage.write(
            key: 'jwtToken', value: await _secureStorage.read(key: 'jwtToken'));
        await _secureStorage.write(
            key: 'usernamePublic',
            value: await _secureStorage.read(key: 'usernamePublic'));
        await _secureStorage.write(
            key: 'userRole', value: await _secureStorage.read(key: 'userRole'));

        userRole = await _secureStorage.read(key: 'userRole') ?? '';
        organizationId = await _secureStorage.read(key: 'organizationId') ?? '';
        emit(SignInSuccess(user));
      });
    } catch (e) {
      emit(SignInFailure("An unexpected error occurred"));
      print("Sign-in error: $e");
    }
  }

  Future<void> dmzSignIn({
    required String uniqueId,
    required String password,
  }) async {
    emit(SignInLoading());
    try {
      var result =
          await loginUseCase.dmzLogin(uniqueId: uniqueId, password: password);

      result.fold((failure) {
        emit(SignInFailure(failure.message));
      }, (user) async {
        // Store DMZ-specific login details in secure storage
        await _secureStorage.write(
            key: 'jwtToken', value: await _secureStorage.read(key: 'jwtToken'));
        await _secureStorage.write(
            key: 'usernamePublic',
            value: 'DMZ'); // Flagging as DMZ user for this key
        await _secureStorage.write(key: 'isDMZAccount', value: 'true');

        isDMZAccount = true;
        emit(SignInDMZUser(user));
      });
    } catch (e) {
      emit(SignInFailure("An unexpected error occurred"));
      print("DMZ sign-in error: $e");
    }
  }
}
