import 'package:e_commerce/feature/orders_history/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersHistoryCubit extends Cubit<OrdersHistoryStates> {
  OrdersHistoryCubit() : super(OrdersHistoryInitial());

  // ignore: strict_top_level_inference
  static OrdersHistoryCubit get(context) => BlocProvider.of(context);

  Future<void> getOrdersHistory() async {
    emit(OrdersHistoryLoading());
    // TODO: implement getOrdersHistory
  }
}
