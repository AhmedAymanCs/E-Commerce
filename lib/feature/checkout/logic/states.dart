abstract class CheckoutStates {}

class CheckoutInitial extends CheckoutStates {}

class GetAddressesLoading extends CheckoutStates {}

class GetAddressesSuccess extends CheckoutStates {}

class PlaceOrderLoading extends CheckoutStates {}

class GetAddressesError extends CheckoutStates {
  final String error;
  GetAddressesError(this.error);
}

class AddAddressLoading extends CheckoutStates {}

class AddAddressSuccess extends CheckoutStates {}

class AddAddressError extends CheckoutStates {
  final String error;
  AddAddressError(this.error);
}

class CheckoutStepChanged extends CheckoutStates {}

class CheckoutPaymentMethodSelected extends CheckoutStates {}

class CheckoutMakePaymentErrorState extends CheckoutStates {
  final String error;
  CheckoutMakePaymentErrorState(this.error);
}

class CheckoutMakePaymentSuccessState extends CheckoutStates {}
