import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/feature/auth/data/models/register_prams_model.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:e_commerce/feature/auth/presentation/register/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;
  RegisterCubit(this._authRepository)
    : super(RegisterState(status: const FormInitial()));

  // ignore: strict_top_level_inference
  static RegisterCubit get(context) => BlocProvider.of(context);

  void changePasswordVisible() {
    emit(state.copyWith(passwordObscure: !state.passwordObscure));
  }

  void register(RegisterParamsModel params) async {
    final bool isValid = validator(params);
    if (isValid) {
      emit(state.copyWith(status: const FormLoading()));
      final userCredential = await _authRepository.register(params);
      userCredential.fold(
        (r) => emit(state.copyWith(status: FormFailure(r))),
        (l) => emit(state.copyWith(status: FormSuccess())),
      );
    }
  }

  bool validator(RegisterParamsModel registerParams) {
    if (registerParams.name.trim().isEmpty) {
      emit(state.copyWith(status: FormFailure(StringManager.nameHint)));
      return false;
    } else if (registerParams.email.trim().isEmpty) {
      emit(state.copyWith(status: FormFailure(StringManager.emailHint)));
      return false;
    } else if (registerParams.phone.trim().isEmpty) {
      emit(state.copyWith(status: FormFailure(StringManager.phoneHint)));
      return false;
    } else if (registerParams.password != registerParams.confirmPassword ||
        registerParams.password.trim().isEmpty) {
      emit(state.copyWith(status: FormFailure(StringManager.passwordNotMatch)));
      return false;
    } else if (registerParams.password.length < 8) {
      emit(state.copyWith(status: FormFailure(StringManager.weekPassword)));
      return false;
    } else {
      return true;
    }
  }
}
