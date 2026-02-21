abstract class RegisterStates {}

class RegisterInitial extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String errorMessage;
  RegisterErrorState(this.errorMessage);
}

class ChangePasswordVisibleState extends RegisterStates {}
