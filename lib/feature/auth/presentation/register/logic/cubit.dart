import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/feature/auth/data/models/register_prams_model.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:e_commerce/feature/auth/presentation/register/logic/states.dart';
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

  void register(RegisterParamsModel params) async {
    final bool isValid = validator(params);
    if (isValid) {
      emit(RegisterLoadingState());
      final userCredential = await _authRepository.register(params);
      userCredential.fold(
        (r) => emit(RegisterErrorState(r)),
        (l) => emit(RegisterSuccessState()),
      );
    }
  }

  bool validator(RegisterParamsModel registerParams) {
    if (registerParams.name.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.nameHint));
      return false;
    } else if (registerParams.email.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.emailHint));
      return false;
    } else if (registerParams.phone.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.phoneHint));
      return false;
    } else if (registerParams.password != registerParams.confirmPassword ||
        registerParams.password.trim().isEmpty) {
      emit(RegisterErrorState(StringManager.passwordNotMatch));
      return false;
    } else if (registerParams.password.length < 8) {
      emit(RegisterErrorState(StringManager.weekPassword));
      return false;
    } else {
      return true;
    }
  }
}
