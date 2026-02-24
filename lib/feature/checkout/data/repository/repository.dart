import 'package:e_commerce/core/stripe_payment/payment_manager.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:e_commerce/feature/checkout/data/data_source/checkout_source.dart';
import 'package:e_commerce/feature/checkout/data/models/address_model.dart';
import 'package:dartz/dartz.dart';

abstract class CheckoutRepo {
  ServerResponse<List<AddressModel>> getAddresses(String userId);

  ServerResponse<void> addAddress({
    required String userId,
    required AddressModel address,
  });
  ServerResponse<void> makePayment(double amount, String currency);
}

class CheckoutRepoImpl implements CheckoutRepo {
  final CheckoutRemoteDataSource _remoteDataSource;

  CheckoutRepoImpl(this._remoteDataSource);

  @override
  ServerResponse<List<AddressModel>> getAddresses(String userId) async {
    try {
      final addresses = await _remoteDataSource.getAddresses(userId);
      return Right(addresses);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> addAddress({
    required String userId,
    required AddressModel address,
  }) async {
    try {
      await _remoteDataSource.addAddress(userId: userId, address: address);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> makePayment(double amount, String currency) async {
    try {
      await PaymentManager.makePayment(amount, currency);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
