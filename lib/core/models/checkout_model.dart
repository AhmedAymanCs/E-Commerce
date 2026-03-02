import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/models/user_model.dart';

class CheckoutArguments {
  final double totalPrice;
  final List<ProductModel> cartList;
  final UserModel userModel;

  CheckoutArguments({
    required this.totalPrice,
    required this.cartList,
    required this.userModel,
  });
}
