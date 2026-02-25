import 'package:e_commerce/core/models/product_model.dart';

class CheckoutArguments {
  final double totalPrice;
  final List<ProductModel> cartList;

  CheckoutArguments({required this.totalPrice, required this.cartList});
}
