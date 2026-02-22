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
  Future<Response> addToWishlist();
  Future<Response> getWishlist();
  Future<Response> getCart();
  Future<void> addToCart(ProductModel product);
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
      key: AppConstants.userSessipn,
    );
    final userId = jsonDecode(userSession!)['uId'];
    _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.cartCollectionName)
        .doc(product.id.toString())
        .set(product.toJson());
  }

  @override
  Future<Response> addToWishlist() {
    // TODO: implement addToWishlist
    throw UnimplementedError();
  }

  @override
  Future<Response> getCart() {
    // TODO: implement getCart
    throw UnimplementedError();
  }

  @override
  Future<Response> getWishlist() {
    // TODO: implement getWishlist
    throw UnimplementedError();
  }
}
