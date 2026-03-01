import 'package:e_commerce/core/stripe_payment/payment_manager.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:e_commerce/feature/checkout/data/data_source/checkout_source.dart';
import 'package:e_commerce/feature/checkout/data/models/address_model.dart';
import 'package:dartz/dartz.dart';
import 'package:e_commerce/feature/checkout/data/models/order_history_model.dart';

abstract class CheckoutRepo {
  ServerResponse<List<AddressModel>> getAddresses(String userId);

  ServerResponse<Unit> addAddress({
    required String userId,
    required AddressModel address,
  });
  ServerResponse<void> makePayment(double amount, String currency);
  ServerResponse<Unit> addOrderHistory(
    String userId,
    OrderHistoryModel orderHistoryModel,
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
  ServerResponse<Unit> addAddress({
    required String userId,
    required AddressModel address,
  }) async {
    try {
      await remoteDataSource.addAddress(userId: userId, address: address);
      return const Right(unit);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> makePayment(double amount, String currency) async {
    return await paymentManager.makePayment(amount, currency);
  }

  @override
  ServerResponse<Unit> addOrderHistory(
    String userId,
    OrderHistoryModel orderHistoryModel,
  ) async {
    try {
      await remoteDataSource.addOrderHistory(userId, orderHistoryModel);
      return const Right(unit);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
