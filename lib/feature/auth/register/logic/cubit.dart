import 'package:e_commerce/feature/auth/register/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  // final AuthRepository _authRepository;
  RegisterCubit() : super(RegisterInitial());

  // ignore: strict_top_level_inference
  static RegisterCubit get(context) => BlocProvider.of(context);

  bool passwordObscure = true;

  void changePasswordVisible() {
    passwordObscure = !passwordObscure;
    emit(ChangePasswordVisibleState());
  }
}
