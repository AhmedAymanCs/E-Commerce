import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/events/app_events.dart';
import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/core/utils/enums.dart';
import 'package:e_commerce/feature/checkout/data/models/address_model.dart';
import 'package:e_commerce/feature/checkout/data/models/order_history_model.dart';
import 'package:e_commerce/feature/checkout/data/repository/repository.dart';
import 'package:e_commerce/feature/checkout/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckoutCubit extends Cubit<CheckOutState> {
  final CheckoutRepo checkoutRepo;
  final FlutterSecureStorage storage;
  final UserModel userModel;

  CheckoutCubit({
    required this.checkoutRepo,
    required this.storage,
    required this.userModel,
  }) : super(CheckOutState(status: const CheckoutInitial()));

  Future<void> fetchAddresses() async {
    emit(state.copyWith(status: const FormLoading()));
    final result = await checkoutRepo.getAddresses(userModel.uId);
    result.fold((error) => emit(state.copyWith(status: FormFailure(error))), (
      addresses,
    ) {
      emit(state.copyWith(savedAddress: addresses));
    });
  }

  Future<void> addNewAddress({required AddressModel address}) async {
    emit(state.copyWith(status: const FormLoading()));
    final result = await checkoutRepo.addAddress(
      userId: userModel.uId,
      address: address,
    );
    result.fold((error) => emit(state.copyWith(status: FormFailure(error))), (
      success,
    ) {
      fetchAddresses();
      emit(state.copyWith(status: FormSuccess()));
    });
  }

  void changeStep(int step) {
    switch (step) {
      case 0:
        emit(state.copyWith(step: CheckoutStep.address));
        break;
      case 1:
        emit(state.copyWith(step: CheckoutStep.payment));
        break;
      case 2:
        emit(state.copyWith(step: CheckoutStep.review));
        break;
    }
  }

  void selectAddress(AddressModel address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void selectPaymentMethod(CashMethods method) {
    emit(state.copyWith(method: method));
  }

  Future<void> confirmOrder(double amount) async {
    if (state.method == CashMethods.stripe) {
      makePayment(amount, AppConstants.currency);
    } else {
      emit(state.copyWith(status: CheckoutMakePaymentSuccessState()));
    }
  }

  Future<void> makePayment(double amount, String currency) async {
    final payment = await checkoutRepo.makePayment(amount, currency);
    payment.fold(
      (error) => emit(state.copyWith(status: FormFailure(error))),
      (success) =>
          emit(state.copyWith(status: CheckoutMakePaymentSuccessState())),
    );
  }

  Future<void> addOrderHistory(OrderHistoryModel orderHistoryModel) async {
    final result = await checkoutRepo.addOrderHistory(
      userModel.uId,
      orderHistoryModel,
    );
    result.fold((error) => emit(state.copyWith(status: FormFailure(error))), (
      success,
    ) {
      eventBus.fire(OrderConfirmedEvent());
      emit(state.copyWith(status: CheckoutAddOrderHistorySuccessState()));
    });
  }
}
