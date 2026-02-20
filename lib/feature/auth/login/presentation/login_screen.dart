import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/cutom_form_field.dart';
import 'package:e_commerce/feature/auth/login/data/repository/repository.dart';
import 'package:e_commerce/feature/auth/login/logic/cubit.dart';
import 'package:e_commerce/feature/auth/login/logic/states.dart';
import 'package:e_commerce/feature/auth/login/presentation/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getIt<AuthRepository>()),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LogoWithText(),
                  SizedBox(height: 20.h),
                  //Email field
                  CustomFormField(
                    controller: _emailController,
                    hint: StringManager.emailHint,
                    title: StringManager.email,
                    preicon: Icons.email_outlined,
                  ),
                  SizedBox(height: 15.h),
                  //Password field
                  BlocBuilder<LoginCubit, LoginStates>(
                    builder: (context, state) {
                      LoginCubit cubit = LoginCubit.get(context);
                      return CustomFormField(
                        controller: _passwordController,
                        hint: StringManager.passwordHint,
                        title: StringManager.password,
                        preicon: Icons.lock_outlined,
                        obscure: cubit.passwordObscure,
                        onPressed: cubit.changePasswordVisible,
                      );
                    },
                  ),
                  BlocBuilder<LoginCubit, LoginStates>(
                    builder: (context, state) {
                      LoginCubit cubit = LoginCubit.get(context);
                      return RememberMeAndForgotPassRow(
                        rememberMeValue: cubit.rememberMe,
                        checkBoxOnPressed: (_) => cubit.changeRememberMe(),
                        forgotPassOnPressed: () {},
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  BlocListener<LoginCubit, LoginStates>(
                    listener: (context, state) {
                      if (state is LoginSuccessState) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.homeRoute,
                          (_) => false,
                        );
                      }
                      if (state is LoginErrorState) {
                        Fluttertoast.showToast(
                          msg: state.errorMessage,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                    child: BlocBuilder<LoginCubit, LoginStates>(
                      builder: (context, state) {
                        LoginCubit cubit = LoginCubit.get(context);
                        if (state is LoginLoadingState) {
                          return const CircularProgressIndicator();
                        } else {
                          return CustomButton(
                            text: StringManager.login,
                            onPressed: () {
                              cubit.login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  RegisterRow(
                    onPressed: () {
                      //TODO: navigate to register page
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
