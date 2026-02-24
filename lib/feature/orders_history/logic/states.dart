abstract class OrdersHistoryStates {}

class OrdersHistoryInitial extends OrdersHistoryStates {}

class OrdersHistoryLoading extends OrdersHistoryStates {}

class OrdersHistorySuccess extends OrdersHistoryStates {}

class OrdersHistoryError extends OrdersHistoryStates {
  final String error;
  OrdersHistoryError(this.error);
}
