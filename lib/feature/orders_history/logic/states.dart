import 'package:e_commerce/feature/orders_history/data/models/order_model.dart';

abstract class OrdersHistoryStates {}

class OrdersHistoryInitial extends OrdersHistoryStates {}

class OrdersHistoryLoading extends OrdersHistoryStates {}

class OrdersHistorySuccess extends OrdersHistoryStates {
  List<OrderModel> ordersHistory;
  OrdersHistorySuccess(this.ordersHistory);
}

class OrdersHistoryError extends OrdersHistoryStates {
  final String error;
  OrdersHistoryError(this.error);
}
