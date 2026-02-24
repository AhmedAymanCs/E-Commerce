import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/database/remote/networking/api_constant.dart';
import 'package:e_commerce/core/database/remote/networking/dio_helper.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<Response> getProducts();
  Future<void> addToWishlist(ProductModel product);
  Future<void> deleteFromWishList(int productId);
  Future<List<ProductModel>> getWishlist();
  Future<List<ProductModel>> getCart();
  Future<void> addToCart(ProductModel product);
  Future<void> deleteFromCart(int productId);
  Future<void> clearCart();
  Future<void> updateQuantityInCart(int productId, int quantity);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioHelper _dio;
  final FirebaseFirestore _firestore;
  HomeRemoteDataSourceImpl(this._dio, this._firestore);
  @override
  Future<Response> getProducts() async {
    return _dio.getData(endPoint: ApiConstant.productEndPoint);
  }

  @override
  Future<void> addToCart(ProductModel product) async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .doc(product.id.toString())
        .set(product.toJson());
  }

  @override
  Future<void> addToWishlist(ProductModel product) async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.wishlistCollectionName)
        .doc(product.id.toString())
        .set(product.toJson());
  }

  @override
  Future<List<ProductModel>> getCart() async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    final querySnapshot = await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<ProductModel>> getWishlist() async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    final querySnapshot = await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.wishlistCollectionName)
        .get();
    return querySnapshot.docs
        .map((doc) => ProductModel.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> deleteFromWishList(int productId) async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.wishlistCollectionName)
        .doc(productId.toString())
        .delete();
  }

  @override
  Future<void> deleteFromCart(int productId) async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .doc(productId.toString())
        .delete();
  }

  @override
  Future<void> updateQuantityInCart(int productId, int quantity) async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .doc(productId.toString())
        .update({'quantity': quantity});
  }

  @override
  Future<void> clearCart() async {
    final userSession = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    final cartCollection = _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName);

    final snapshot = await cartCollection.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
