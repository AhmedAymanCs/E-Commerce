import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/cutom_form_field.dart';
import 'package:e_commerce/core/widgets/logo_with_text.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:e_commerce/feature/auth/forget_passoword/logic/cubit.dart';
import 'package:e_commerce/feature/auth/forget_passoword/logic/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ForgetPasswordCubit(getIt<AuthRepository>()),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWithText(text: StringManager.forgotPassword),
                  const SizedBox(height: 20.0),
                  CustomFormField(
                    controller: _emailController,
                    hint: StringManager.emailHint,
                  ),
                  const SizedBox(height: 20.0),
                  BlocListener<ForgetPasswordCubit, ForgetPasswordStates>(
                    listener: (context, state) {
                      if (state is ForgetPasswordSuccessState) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.loginRoute,
                          (_) => false,
                        );
                      }
                      if (state is ForgetPasswordErrorState) {
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
                    child:
                        BlocBuilder<ForgetPasswordCubit, ForgetPasswordStates>(
                          buildWhen: (previos, current) {
                            return current is ForgetPasswordLoadingState ||
                                current is ForgetPasswordErrorState;
                          },
                          builder: (context, state) {
                            ForgetPasswordCubit cubit = ForgetPasswordCubit.get(
                              context,
                            );
                            if (state is ForgetPasswordLoadingState) {
                              return const CircularProgressIndicator();
                            }
                            return CustomButton(
                              text: StringManager.forgotPassword,
                              onPressed: () {
                                if (cubit.validateEmail(
                                  _emailController.text,
                                )) {
                                  cubit.forgetPassword(_emailController.text);
                                }
                              },
                            );
                          },
                        ),
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
