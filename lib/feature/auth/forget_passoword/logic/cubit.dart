import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:e_commerce/feature/auth/forget_passoword/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  final AuthRepository _authRepository;
  ForgetPasswordCubit(this._authRepository)
    : super(ForgetPasswordInitialState());

  // ignore: strict_top_level_inference
  static ForgetPasswordCubit get(context) => BlocProvider.of(context);
  Future<void> forgetPassword(String email) async {
    emit(ForgetPasswordLoadingState());
    final userCredential = await _authRepository.sendPasswordResetEmail(
      email: email,
    );
    userCredential.fold(
      (r) => emit(ForgetPasswordErrorState(r)),
      (l) => emit(ForgetPasswordSuccessState()),
    );
    emit(ForgetPasswordLoadingState());
  }

  bool validateEmail(String email) {
    if (email.trim().isEmpty) {
      emit(ForgetPasswordErrorState(StringManager.emailHint));
      return false;
    }
    return true;
  }
}
