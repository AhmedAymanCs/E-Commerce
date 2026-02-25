import 'package:e_commerce/core/models/user_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final UserModel userModel;
  LoginSuccessState(this.userModel);
}

class LoginErrorState extends LoginStates {
  final String errorMessage;

  LoginErrorState(this.errorMessage);
}

class ChangePasswordVisibleState extends LoginStates {}

class ChangeRememberMeState extends LoginStates {}
