import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/cutom_form_field.dart';
import 'package:e_commerce/core/widgets/logo_with_text.dart';
import 'package:e_commerce/feature/auth/register/logic/cubit.dart';
import 'package:e_commerce/feature/auth/register/logic/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWithText(text: StringManager.subTitleRegisterPage),
                  SizedBox(height: 20.h),
                  //Name field
                  CustomFormField(
                    controller: _nameController,
                    hint: StringManager.nameHint,
                    title: StringManager.name,
                    preicon: Icons.person_outlined,
                  ),
                  SizedBox(height: 15.h),
                  //phone field
                  CustomFormField(
                    controller: _phoneController,
                    hint: StringManager.phoneHint,
                    title: StringManager.phone,
                    preicon: Icons.phone_android_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 15.h),
                  //Email field
                  CustomFormField(
                    controller: _emailController,
                    hint: StringManager.emailHint,
                    title: StringManager.email,
                    preicon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15.h),
                  //Password field
                  BlocBuilder<RegisterCubit, RegisterStates>(
                    builder: (context, state) {
                      RegisterCubit cubit = RegisterCubit.get(context);
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
                  SizedBox(height: 20.h),
                  //Confirm Password field
                  BlocBuilder<RegisterCubit, RegisterStates>(
                    builder: (context, state) {
                      RegisterCubit cubit = RegisterCubit.get(context);
                      return CustomFormField(
                        controller: _confirmPasswordController,
                        hint: StringManager.confirmPasswordHint,
                        title: StringManager.confirmPassword,
                        preicon: Icons.lock_outlined,
                        obscure: cubit.passwordObscure,
                      );
                    },
                  ),
                  SizedBox(height: 50.h),
                  BlocListener<RegisterCubit, RegisterStates>(
                    listener: (context, state) {
                      if (state is RegisterSuccessState) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.loginRoute,
                          (_) => false,
                        );
                      }
                      if (state is RegisterErrorState) {
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
                    child: BlocBuilder<RegisterCubit, RegisterStates>(
                      buildWhen: (previous, current) {
                        return current is RegisterLoadingState ||
                            current is RegisterErrorState;
                      },
                      builder: (context, state) {
                        RegisterCubit cubit = RegisterCubit.get(context);
                        if (state is RegisterLoadingState) {
                          return const CircularProgressIndicator();
                        } else {
                          return CustomButton(
                            text: StringManager.signUp,
                            onPressed: () {},
                          );
                        }
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
