import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:e_commerce/feature/auth/presentation/login/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(LoginState());

  // ignore: strict_top_level_inference
  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);

  bool rememberMe = true;

  void changePasswordVisible() {
    emit(state.copyWith(passwordObscure: !state.passwordObscure));
  }

  void changeRememberMe() {
    emit(LoginState(rememberMe: !rememberMe));
  }

  Future<void> login({required String email, required String password}) async {
    final bool isValid = validator(email: email, password: password);
    if (isValid) {
      emit(LoginState(status: const FormLoading()));
      final userCredential = await _authRepository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      userCredential.fold((r) => emit(LoginState(status: FormFailure(r))), (l) {
        emit(LoginState(status: FormSuccess(l)));
      });
    }
  }

  bool validator({required String email, required String password}) {
    if (email.trim().isEmpty) {
      emit(LoginState(status: FormFailure(StringManager.emailHint)));
      return false;
    } else if (password.trim().isEmpty) {
      emit(LoginState(status: FormFailure(StringManager.passwordHint)));
      return false;
    } else {
      return true;
    }
  }
}
