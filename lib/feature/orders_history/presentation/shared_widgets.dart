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
        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) => OrderDetails(order: order),
            );
          },
          child: Card(
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
        borderRadius: AppRadius.card,
      ),
      child: Text(
        status,
        style: TextStyle(
          color: status == 'Pending' ? Colors.orange : ColorManager.green,
          fontSize: FontSize.s12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class OrderDetails extends StatelessWidget {
  final OrderModel order;
  const OrderDetails({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeightManager.bold),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: order.products.length,
              itemBuilder: (context, index) {
                final product = order.products[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Image.network(
                    product.images[0],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text("Quantity: ${product.quantity}"),
                  trailing: Text("\$${product.price}"),
                );
              },
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Amount with Tax",
                style: TextStyle(fontWeight: FontWeightManager.bold),
              ),
              Text(
                "\$${order.totalPrice}",
                style: TextStyle(
                  color: ColorManager.primaryColor,
                  fontWeight: FontWeightManager.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
