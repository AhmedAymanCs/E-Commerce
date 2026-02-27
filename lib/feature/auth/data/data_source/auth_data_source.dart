import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/feature/auth/data/models/register_prams_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> login({
    required String email,
    required String password,
  });
  Future<UserCredential> register(RegisterParamsModel params);
  Future<void> sendPasswordResetEmail({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  AuthRemoteDataSourceImpl(this._firebaseAuth);
  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> register(RegisterParamsModel params) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: params.email,
          password: params.password,
        );
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(credential.user!.uid)
        .set(params.toMap());
    return credential;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
