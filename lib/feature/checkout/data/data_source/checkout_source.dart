import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/feature/checkout/data/models/address_model.dart';
import 'package:e_commerce/feature/checkout/data/models/order_history_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<void> addAddress({
    required String userId,
    required AddressModel address,
  });
  Future<List<AddressModel>> getAddresses(String userId);
  Future<void> addOrderHistory(
    String userId,
    OrderHistoryModel orderHistoryModel,
  );
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final FirebaseFirestore _firestore;

  CheckoutRemoteDataSourceImpl(this._firestore);

  @override
  Future<void> addAddress({
    required String userId,
    required AddressModel address,
  }) async {
    await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.addressesCollectionName)
        .add(address.toFirestore());
  }

  @override
  Future<List<AddressModel>> getAddresses(String userId) async {
    var snapshot = await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.addressesCollectionName)
        .get();
    return snapshot.docs.map((doc) {
      return AddressModel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<void> addOrderHistory(
    String userId,
    OrderHistoryModel orderHistoryModel,
  ) async {
    await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.orderHistoryCollectionName)
        .doc(DateTime.now().toIso8601String())
        .set(orderHistoryModel.toJson());
  }

  // @override
  // Future<void> addOrderHistory(
  //   String userId,
  //   List<ProductModel> products,
  //   double totalPrice,
  // ) async {
  //   await _firestore
  //       .collection(AppConstants.usersCollectionName)
  //       .doc(userId)
  //       .collection(AppConstants.orderHistoryCollectionName)
  //       .doc(DateTime.now().toIso8601String())
  //       .set({
  //         'products': products.map((product) => product.toJson()).toList(),
  //         'orderDate': DateTime.now().toIso8601String(),
  //         'totalPrice': totalPrice,
  //       });
  // }
}
