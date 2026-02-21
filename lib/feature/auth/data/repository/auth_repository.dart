import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:e_commerce/feature/auth/data/data_scource/auth_data_source.dart';
import 'package:e_commerce/feature/auth/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  ServerResponse<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  ServerResponse<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final userCredential = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );
      if (userCredential.user != null && rememberMe) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        String sessionData = jsonEncode(userModel.toJson());
        await getIt<SecureStorageHelper>().saveData(
          key: 'user_session',
          value: sessionData,
        );
      }
      return Right(UserModel.fromFirebaseUser(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(StringManager.userNotFound);
      } else if (e.code == 'network-request-failed') {
        return Left(StringManager.checkYourInternet);
      }
      return Left(e.message ?? 'Something went wrong');
    }
  }
}
