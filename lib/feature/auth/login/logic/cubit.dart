import 'package:e_commerce/feature/auth/login/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of<LoginCubit>(context);
  bool passwordVisible = false;
  bool rememberMe = false;

  void changePasswordVisible() {
    passwordVisible = !passwordVisible;
    emit(ChangePasswordVisibleState());
  }

  void changeRememberMe() {
    rememberMe = !rememberMe;
    emit(ChangeRememberMeState());
  }
}
