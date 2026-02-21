import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:e_commerce/feature/auth/register/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final AuthRepository _authRepository;
  RegisterCubit(this._authRepository) : super(RegisterInitial());

  // ignore: strict_top_level_inference
  static RegisterCubit get(context) => BlocProvider.of(context);

  bool passwordObscure = true;

  void changePasswordVisible() {
    passwordObscure = !passwordObscure;
    emit(ChangePasswordVisibleState());
  }

  void register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoadingState());
    final userCredential = await _authRepository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
    userCredential.fold(
      (r) => emit(RegisterErrorState(r)),
      (l) => emit(RegisterSuccessState()),
    );
  }

  bool validator({
    required String password,
    required String confirmPassword,
    required String email,
    required String name,
    required String phone,
  }) {
    if (name.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.nameHint));
      return false;
    } else if (email.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.emailHint));
      return false;
    } else if (phone.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.phoneHint));
      return false;
    } else if (password != confirmPassword || password.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.passwordNotMatch));
      return false;
    } else if (password.length < 8) {
      emit(RegisterErrorState(StringManager.weekPassword));
      return false;
    } else {
      return true;
    }
  }
}
