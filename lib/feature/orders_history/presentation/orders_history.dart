import 'package:e_commerce/core/di/service_locator.dart';
import 'package:e_commerce/feature/orders_history/data/repository/repositroy.dart';
import 'package:e_commerce/feature/orders_history/logic/cubit.dart';
import 'package:e_commerce/feature/orders_history/logic/states.dart';
import 'package:e_commerce/feature/orders_history/presentation/shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersHistory extends StatelessWidget {
  const OrdersHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersHistoryCubit(getIt<OrdersHistoryRepository>())
            ..getOrdersHistory(),
      child: Scaffold(
        appBar: AppBar(title: const Text("My Orders")),
        body: BlocBuilder<OrdersHistoryCubit, OrdersHistoryStates>(
          builder: (context, state) {
            if (state is OrdersHistorySuccess) {
              if (state.ordersHistory.isEmpty) {
                return const Center(child: Text("No Orders Found"));
              }
              return OrderHistoryList(orders: state.ordersHistory);
            }
            if (state is OrdersHistoryError) {
              return Center(child: Text('Error :${state.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
