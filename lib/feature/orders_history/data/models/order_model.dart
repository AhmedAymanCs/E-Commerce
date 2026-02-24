import 'package:e_commerce/core/models/product_model.dart';

class OrderModel {
  final String status;
  final List<ProductModel> products;
  final double totalPrice;
  final DateTime date;

  OrderModel({
    required this.status,
    required this.products,
    required this.totalPrice,
    required this.date,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      status: json['status'] ?? 'Pending',
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      date: DateTime.parse(json['orderDate'] ?? ''),
    );
  }
}
