import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/feature/orders_history/data/models/order_model.dart';

abstract class OrdersHistoryRemoteDataSource {
  Future<List<OrderModel>> getOrdersHistory();
}

class OrdersHistoryRemoteDataSourceImpl
    implements OrdersHistoryRemoteDataSource {
  final FirebaseFirestore _firestore;
  OrdersHistoryRemoteDataSourceImpl(this._firestore);

  @override
  Future<List<OrderModel>> getOrdersHistory() async {
    final session = await getIt<SecureStorageHelper>().getData(
      key: AppConstants.userSession,
    );
    final userId = jsonDecode(session!)['uId'];
    final snapshot = await _firestore
        .collection(AppConstants.usersCollectionName)
        .doc(userId)
        .collection(AppConstants.orderHistoryCollectionName)
        .get();
    return snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
  }
}
