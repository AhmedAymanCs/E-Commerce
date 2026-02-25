import 'package:e_commerce/core/models/product_model.dart';
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
  ServerResponse<void> addOrderHistory(
    String userId,
    List<ProductModel> products,
    totalPrice,
  );
}

class CheckoutRepoImpl implements CheckoutRepo {
  final CheckoutRemoteDataSource remoteDataSource;
  final PaymentManager paymentManager;
  CheckoutRepoImpl({
    required this.remoteDataSource,
    required this.paymentManager,
  });

  @override
  ServerResponse<List<AddressModel>> getAddresses(String userId) async {
    try {
      final addresses = await remoteDataSource.getAddresses(userId);
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
      await remoteDataSource.addAddress(userId: userId, address: address);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> makePayment(double amount, String currency) async {
    return await paymentManager.makePayment(amount, currency);
  }

  @override
  ServerResponse<void> addOrderHistory(
    String userId,
    List<ProductModel> products,
    totalPrice,
  ) async {
    try {
      await remoteDataSource.addOrderHistory(userId, products, totalPrice);
      return const Right(null);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
