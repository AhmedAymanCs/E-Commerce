import 'package:e_commerce/feature/auth/forget_passoword/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit() : super(ForgetPasswordInitialState());

  // ignore: strict_top_level_inference
  static ForgetPasswordCubit get(context) => BlocProvider.of(context);
  void forgetPassword() {
    emit(ForgetPasswordLoadingState());
  }
}
