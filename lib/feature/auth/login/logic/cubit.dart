import 'package:e_commerce/feature/auth/login/data/repository/repository.dart';
import 'package:e_commerce/feature/auth/login/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(LoginInitialState());

  // ignore: strict_top_level_inference
  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  bool passwordObscure = true;
  bool rememberMe = true;

  void changePasswordVisible() {
    passwordObscure = !passwordObscure;
    emit(ChangePasswordVisibleState());
  }

  void changeRememberMe() {
    rememberMe = !rememberMe;
    emit(ChangeRememberMeState());
  }

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoadingState());
    final userCredential = await _authRepository.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
    userCredential.fold(
      (r) => emit(LoginErrorState(r)),
      (l) => emit(LoginSuccessState(l)),
    );
  }
}
