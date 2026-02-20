import 'dart:convert';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/feature/auth/login/data/model/user_model.dart';
import 'package:e_commerce/feature/splash/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit(this._storage) : super(SplashInitialState());

  // ignore: strict_top_level_inference
  static SplashCubit get(context) => BlocProvider.of(context);

  final SecureStorageHelper _storage;

  void startSplash() async {
    emit(SplashLoadingState());

    try {
      await Future.delayed(const Duration(seconds: 2));
      await getStoredUserSession();
    } catch (error) {
      emit(SplashLoginState());
    }
  }

  Future<void> getStoredUserSession() async {
    try {
      final String? sessionData = await _storage.getData(key: 'user_session');
      if (sessionData != null) {
        final userModel = UserModel.fromJson(jsonDecode(sessionData));
        emit(SplashAuthenticatedState(userModel));
      } else {
        emit(SplashLoginState());
      }
    } catch (e) {
      emit(SplashLoginState());
    }
  }
}
