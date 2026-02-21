import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:e_commerce/feature/auth/data/data_scource/auth_data_source.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  ServerResponse<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });
  ServerResponse<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
  ServerResponse<void> sendPasswordResetEmail({required String email});
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

      if (userCredential.user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists && userDoc.data() != null) {
          final userModel = UserModel.fromJson(userDoc.data()!);

          if (rememberMe) {
            String sessionData = jsonEncode(userModel.toJson());
            await getIt<SecureStorageHelper>().saveData(
              key: 'user_session',
              value: sessionData,
            );
          }

          return Right(userModel);
        } else {
          return Left("User data record not found in database");
        }
      }
      return Left("Authentication failed");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(StringManager.userNotFound);
      }
      return Left(e.message ?? 'Something went wrong');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      await _authRemoteDataSource.register(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Left(StringManager.weekPassword);
      } else if (e.code == 'email-already-in-use') {
        return Left(StringManager.emailAlreadyInUse);
      }
      return Left(e.message ?? 'Authentication Error');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _authRemoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
