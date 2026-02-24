import 'dart:convert';
import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/feature/checkout/data/models/address_model.dart';
import 'package:e_commerce/feature/checkout/data/repository/repository.dart';
import 'package:e_commerce/feature/checkout/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CheckoutCubit extends Cubit<CheckoutStates> {
  final CheckoutRepo _checkoutRepo;
  CheckoutCubit(this._checkoutRepo) : super(CheckoutInitial());

  // ignore: strict_top_level_inference
  static CheckoutCubit get(context) => BlocProvider.of(context);

  int currentStep = 0;
  List<AddressModel> savedAddresses = [];
  AddressModel? selectedAddress;
  String paymentMethod = 'Cash';
  String userId = "";

  Future<void> initUserId() async {
    final storage = getIt<FlutterSecureStorage>();
    String sessionJson =
        await storage.read(key: AppConstants.userSession) ?? "";
    if (sessionJson.isNotEmpty) {
      userId = jsonDecode(sessionJson)['uId'];
    }
  }

  Future<void> fetchAddresses() async {
    emit(GetAddressesLoading());
    if (userId.isEmpty) {
      await initUserId();
    }
    final result = await _checkoutRepo.getAddresses(userId);
    result.fold((error) => emit(GetAddressesError(error)), (addresses) {
      savedAddresses = addresses;
      emit(GetAddressesSuccess());
    });
  }

  Future<void> addNewAddress({required AddressModel address}) async {
    emit(AddAddressLoading());
    final result = await _checkoutRepo.addAddress(
      userId: userId,
      address: address,
    );
    result.fold((error) => emit(AddAddressError(error)), (success) {
      fetchAddresses();
      emit(AddAddressSuccess());
    });
  }

  void changeStep(int step) {
    currentStep = step;
    emit(CheckoutStepChanged());
  }

  void selectAddress(AddressModel address) {
    selectedAddress = address;
    emit(CheckoutStepChanged());
  }

  void selectPaymentMethod(String method) {
    paymentMethod = method;
    emit(CheckoutPaymentMethodSelected());
  }
}
