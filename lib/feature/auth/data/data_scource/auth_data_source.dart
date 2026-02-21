import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> login({
    required String email,
    required String password,
  });
  Future<UserCredential> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
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
  Future<UserCredential> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(credential.user!.uid)
        .set({
          'uId': credential.user!.uid,
          'name': name,
          'phone': phone,
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
          'imageUrl': '', //late add
          'city': '', //late add
          'street': '', //late add
        });
    return credential;
  }
}
