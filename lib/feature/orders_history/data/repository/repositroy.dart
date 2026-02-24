import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:e_commerce/feature/orders_history/data/data_source/data_source.dart';
import 'package:e_commerce/feature/orders_history/data/models/order_model.dart';

abstract class OrdersHistoryRepository {
  ServerResponse<List<OrderModel>> getOrdersHistory();
}

class OrdersHistoryRepositoryImpl implements OrdersHistoryRepository {
  final OrdersHistoryRemoteDataSource _ordersHistoryRemoteDataSource;
  OrdersHistoryRepositoryImpl(this._ordersHistoryRemoteDataSource);

  @override
  ServerResponse<List<OrderModel>> getOrdersHistory() async {
    try {
      final ordersHistory = await _ordersHistoryRemoteDataSource
          .getOrdersHistory();
      return Right(ordersHistory);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
