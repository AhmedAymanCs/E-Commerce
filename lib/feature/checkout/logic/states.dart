import 'package:e_commerce/core/utils/enums.dart';
import 'package:e_commerce/feature/checkout/data/models/address_model.dart';
import 'package:equatable/equatable.dart';

abstract class FormStatus extends Equatable {
  const FormStatus();
}

class CheckOutState extends Equatable {
  final CheckoutStep step;
  final CashMethods method;
  final FormStatus status;
  final AddressModel? selectedAddress;
  final List<AddressModel> savedAddress;
  const CheckOutState({
    this.step = CheckoutStep.address,
    this.status = const CheckoutInitial(),
    this.method = CashMethods.onDelivery,
    this.selectedAddress,
    this.savedAddress = const [],
  });
  CheckOutState copyWith({
    CheckoutStep? step,
    FormStatus? status,
    CashMethods? method,
    AddressModel? selectedAddress,
    List<AddressModel>? savedAddress,
  }) {
    return CheckOutState(
      step: step ?? this.step,
      status: status ?? this.status,
      method: method ?? this.method,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      savedAddress: savedAddress ?? this.savedAddress,
    );
  }

  @override
  List<Object?> get props => [
    step,
    status,
    method,
    selectedAddress,
    savedAddress,
  ];
}

class CheckoutInitial extends FormStatus {
  const CheckoutInitial();
  @override
  List<Object?> get props => [];
}

class GetAddressesSuccess extends FormStatus {
  final List<AddressModel> addresses;
  const GetAddressesSuccess(this.addresses);
  @override
  List<Object?> get props => [addresses];
}

class FormLoading extends FormStatus {
  const FormLoading();
  @override
  List<Object?> get props => [];
}

class FormSuccess extends FormStatus {
  const FormSuccess();
  @override
  List<Object?> get props => [];
}

class FormFailure extends FormStatus {
  final String error;
  const FormFailure(this.error);
  @override
  List<Object?> get props => [error];
}

class CheckoutStepChanged extends FormStatus {
  final CheckoutStep step;
  const CheckoutStepChanged(this.step);
  @override
  List<Object?> get props => [step];
}

class CheckoutPaymentMethodSelected extends FormStatus {
  final CashMethods method;
  const CheckoutPaymentMethodSelected(this.method);
  @override
  List<Object?> get props => [method];
}

class CheckoutMakePaymentSuccessState extends FormStatus {
  const CheckoutMakePaymentSuccessState();
  @override
  List<Object?> get props => [];
}

class CheckoutAddOrderHistorySuccessState extends FormStatus {
  const CheckoutAddOrderHistorySuccessState();
  @override
  List<Object?> get props => [];
}
