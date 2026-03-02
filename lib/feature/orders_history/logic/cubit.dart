import 'package:e_commerce/feature/orders_history/data/repository/repositroy.dart';
import 'package:e_commerce/feature/orders_history/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersHistoryCubit extends Cubit<OrdersHistoryStates> {
  final OrdersHistoryRepository _ordersHistoryRepository;
  OrdersHistoryCubit(this._ordersHistoryRepository)
    : super(OrdersHistoryInitial());

  // ignore: strict_top_level_inference
  static OrdersHistoryCubit get(context) => BlocProvider.of(context);
  Future<void> getOrdersHistory() async {
    emit(OrdersHistoryLoading());
    final result = await _ordersHistoryRepository.getOrdersHistory();
    result.fold((error) => emit(OrdersHistoryError(error)), (ordersHistory) {
      ordersHistory.sort((a, b) => b.date.compareTo(a.date));
      ordersHistory = ordersHistory.reversed.toList();
      emit(OrdersHistorySuccess(ordersHistory));
    });
  }
}
