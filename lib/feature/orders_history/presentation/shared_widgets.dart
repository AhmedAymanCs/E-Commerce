import 'package:e_commerce/core/constants/app_constants.dart';
import 'package:e_commerce/core/constants/color_manager.dart';
import 'package:e_commerce/core/constants/font_manager.dart';
import 'package:e_commerce/feature/orders_history/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryList extends StatelessWidget {
  final List<OrderModel> orders;
  const OrderHistoryList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.card,
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order #${index + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    StatusBadge(status: order.status),
                  ],
                ),
                const Divider(height: 24),
                Text("${order.products.length} Items"),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat.yMMMd().format(order.date),
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    Text(
                      "\$${order.totalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeightManager.semiBold,
                        color: ColorManager.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status == 'Pending'
            ? Colors.orange.shade50
            : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == 'Pending' ? Colors.orange : ColorManager.green,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
