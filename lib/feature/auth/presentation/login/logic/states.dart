import 'package:e_commerce/core/models/user_model.dart';
import 'package:equatable/equatable.dart';

// abstract class LoginStates {}

// class LoginInitialState extends LoginStates {}

// class LoginLoadingState extends LoginStates {}

// class LoginSuccessState extends LoginStates {
//   final UserModel userModel;
//   LoginSuccessState(this.userModel);
// }

// class LoginErrorState extends LoginStates {
//   final String errorMessage;

//   LoginErrorState(this.errorMessage);
// }

// class ChangePasswordVisibleState extends LoginStates {}

// class ChangeRememberMeState extends LoginStates {}

class LoginState extends Equatable {
  final bool passwordObscure;
  final bool rememberMe;
  final FormStatus status;

  const LoginState({
    this.passwordObscure = true,
    this.rememberMe = false,
    this.status = const FormInitial(),
  });

  LoginState copyWith({
    bool? passwordObscure,
    bool? rememberMe,
    FormStatus? status,
  }) {
    return LoginState(
      passwordObscure: passwordObscure ?? this.passwordObscure,
      rememberMe: rememberMe ?? this.rememberMe,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [passwordObscure, rememberMe, status];
}

abstract class FormStatus extends Equatable {
  const FormStatus();
}

class FormInitial extends FormStatus {
  const FormInitial();

  @override
  List<Object?> get props => [];
}

class FormLoading extends FormStatus {
  const FormLoading();

  @override
  List<Object?> get props => [];
}

class FormSuccess extends FormStatus {
  final UserModel userModel;
  const FormSuccess(this.userModel);
  @override
  List<Object?> get props => [userModel];
}

class FormFailure extends FormStatus {
  final String message;

  const FormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
