import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:e_commerce/feature/auth/login/data/data_scource/data_source.dart';
import 'package:e_commerce/feature/auth/login/data/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthRepository {
  ServerResponse<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  AuthRepositoryImpl(this._authRemoteDataSource);

  @override
  ServerResponse<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authRemoteDataSource.login(
        email: email,
        password: password,
      );
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
