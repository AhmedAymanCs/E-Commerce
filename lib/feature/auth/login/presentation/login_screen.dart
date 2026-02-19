import 'package:e_commerce/core/constants/string_manager.dart';
import 'package:e_commerce/core/widgets/custom_button.dart';
import 'package:e_commerce/core/widgets/cutom_form_field.dart';
import 'package:e_commerce/feature/auth/login/logic/cubit.dart';
import 'package:e_commerce/feature/auth/login/logic/states.dart';
import 'package:e_commerce/feature/auth/login/presentation/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LogoWithText(),
                  SizedBox(height: 20.h),
                  //Email field
                  const CustomFormField(
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
                        hint: StringManager.passwordHint,
                        title: StringManager.password,
                        preicon: Icons.lock_outlined,
                        obscure: cubit.passwordVisible,
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
                  CustomButton(text: StringManager.login, onPressed: () {}),
                  SizedBox(height: 20.h),
                  RegisterRow(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
