import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/database/remote/networking/api_constant.dart';
import 'package:e_commerce/core/database/remote/networking/dio_helper.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<void> signOut();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioHelper dio;
  final FirebaseFirestore firestore;
  final SecureStorageHelper secureStorageHelper;
  final FirebaseAuth firebaseAuth;
  HomeRemoteDataSourceImpl({
    required this.dio,
    required this.firestore,
    required this.secureStorageHelper,
    required this.firebaseAuth,
  });
  @override
  Future<Response> getProducts() async {
    return dio.getData(endPoint: ApiConstant.productEndPoint);
  }

  @override
  Future<void> addToCart(ProductModel product) async {
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .doc(product.id.toString())
        .set(product.toJson());
  }

  @override
  Future<void> addToWishlist(ProductModel product) async {
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.wishlistCollectionName)
        .doc(product.id.toString())
        .set(product.toJson());
  }

  @override
  Future<List<ProductModel>> getCart() async {
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    final querySnapshot = await firestore
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
    final querySnapshot = await firestore
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
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.wishlistCollectionName)
        .doc(productId.toString())
        .delete();
  }

  @override
  Future<void> deleteFromCart(int productId) async {
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    await firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .doc(productId.toString())
        .delete();
  }

  @override
  Future<void> updateQuantityInCart(int productId, int quantity) async {
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .doc(productId.toString())
        .update({'quantity': quantity});
  }

  @override
  Future<void> clearCart() async {
    final userSession = await secureStorageHelper.getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(userSession!)['uId'];
    final cartCollection = firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName);

    final snapshot = await cartCollection.get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
