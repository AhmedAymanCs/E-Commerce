import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/feature/checkout/data/repository/repository.dart';
import 'package:e_commerce/feature/checkout/logic/cubit.dart';
import 'package:e_commerce/feature/checkout/logic/states.dart';
import 'package:e_commerce/feature/checkout/presentation/shared_widgets.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckoutScreen extends StatelessWidget {
  final double totalPrice;
  final List<ProductModel> cartList;
  const CheckoutScreen({
    super.key,
    required this.totalPrice,
    required this.cartList,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(getIt<CheckoutRepo>())
        ..initUserId()
        ..fetchAddresses(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Checkout")),
        body: BlocBuilder<CheckoutCubit, CheckoutStates>(
          builder: (context, state) {
            CheckoutCubit cubit = CheckoutCubit.get(context);
            if (state is CheckoutAddOrderHistorySuccessState) {
              return const ConfirmedOrderView();
            }
            if (state is CheckoutMakePaymentSuccessState) {
              cubit.addOrderHistory(cartList, totalPrice);
            }
            if (state is CheckoutMakePaymentErrorState) {
              Fluttertoast.showToast(
                msg: state.error,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
            return Stepper(
              type: StepperType.vertical,
              currentStep: cubit.currentStep,
              onStepContinue: () {
                if (cubit.currentStep == 0 && cubit.selectedAddress == null) {
                  Fluttertoast.showToast(
                    msg: "Please Select Address",
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                  return;
                }
                if (cubit.currentStep < 2) {
                  cubit.changeStep(cubit.currentStep + 1);
                } else {
                  cubit.confirmOrder(totalPrice);
                }
              },
              onStepCancel: () {
                if (cubit.currentStep > 0) {
                  cubit.changeStep(cubit.currentStep - 1);
                } else {
                  Navigator.pop(context);
                }
              },
              onStepTapped: (step) {
                if (step < cubit.currentStep) {
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
                  isActive: cubit.currentStep >= 0,
                  state: cubit.currentStep > 0
                      ? StepState.complete
                      : StepState.indexed,
                  title: const Text("Address"),
                  content: const AddressStepWidget(),
                ),
                Step(
                  isActive: cubit.currentStep >= 1,
                  state: cubit.currentStep > 1
                      ? StepState.complete
                      : StepState.indexed,
                  title: const Text("Payment"),
                  content: PaymentStepWidget(totalAmount: totalPrice),
                ),
                Step(
                  isActive: cubit.currentStep >= 2,
                  title: const Text("Summary"),
                  content: SummaryStepWidget(totalPrice: totalPrice),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
