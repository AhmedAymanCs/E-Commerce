import 'package:e_commerce/core/models/product_model.dart';

class OrderHistoryModel {
  List<ProductModel> products;
  double totalPrice;
  String? status;
  DateTime date;

  OrderHistoryModel({
    required this.products,
    required this.totalPrice,
    this.status,
    required this.date,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrderHistoryModel(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e))
          .toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
      date: DateTime.parse(json['orderDate'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products.map((product) => product.toJson()).toList(),
      'totalPrice': totalPrice,
      'status': status ?? 'Pending',
      'orderDate': date.toIso8601String(),
    };
  }
}
