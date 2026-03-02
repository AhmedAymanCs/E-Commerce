import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/feature/checkout/data/models/order_history_model.dart';
import 'package:e_commerce/feature/checkout/data/repository/repository.dart';
import 'package:e_commerce/feature/checkout/logic/cubit.dart';
import 'package:e_commerce/feature/checkout/logic/states.dart';
import 'package:e_commerce/feature/checkout/presentation/shared_widgets.dart';
import 'package:e_commerce/core/models/checkout_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatelessWidget {
  final CheckoutArguments arguments;
  const CheckoutScreen({super.key, required this.arguments});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(
        checkoutRepo: getIt<CheckoutRepo>(),
        storage: getIt<FlutterSecureStorage>(),
        userModel: arguments.userModel,
      )..fetchAddresses(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Checkout")),
        body: BlocBuilder<CheckoutCubit, CheckOutState>(
          builder: (context, state) {
            CheckoutCubit cubit = context.read<CheckoutCubit>();
            if (state.status is CheckoutAddOrderHistorySuccessState) {
              return const ConfirmedOrderView();
            }
            if (state.status is CheckoutMakePaymentSuccessState) {
              cubit.addOrderHistory(
                OrderHistoryModel(
                  products: arguments.cartList,
                  totalPrice: arguments.totalPrice,
                  date: DateTime.now(),
                ),
              );
            }
            if (state.status is FormFailure) {
              final error = (state.status as FormFailure).error;
              Fluttertoast.showToast(
                msg: error,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
            return Stepper(
              type: StepperType.vertical,
              currentStep: state.step.index,
              onStepContinue: () {
                if (state.step.index == 0 && state.selectedAddress == null) {
                  Fluttertoast.showToast(
                    msg: "Please Select Address",
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }
                if (state.step.index < 2) {
                  cubit.changeStep(state.step.index + 1);
                } else {
                  cubit.confirmOrder(arguments.totalPrice);
                }
              },
              onStepCancel: () {
                if (state.step.index > 0) {
                  cubit.changeStep(state.step.index - 1);
                } else {
                  Navigator.pop(context);
                }
              },
              onStepTapped: (step) {
                if (step < state.step.index) {
                  cubit.changeStep(step);
                } else {
                  Fluttertoast.showToast(
                    msg: "Please Finish the Previous Step",
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              steps: [
                Step(
                  isActive: state.step.index >= 0,
                  state: state.step.index > 0
                      ? StepState.complete
                      : StepState.indexed,
                  title: const Text("Address"),
                  content: const AddressStepWidget(),
                ),
                Step(
                  isActive: state.step.index >= 1,
                  state: state.step.index > 1
                      ? StepState.complete
                      : StepState.indexed,
                  title: const Text("Payment"),
                  content: PaymentStepWidget(totalAmount: arguments.totalPrice),
                ),
                Step(
                  isActive: state.step.index >= 2,
                  title: const Text("Summary"),
                  content: SummaryStepWidget(totalPrice: arguments.totalPrice),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
