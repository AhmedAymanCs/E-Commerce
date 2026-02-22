import 'package:e_commerce/core/models/product_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeGetProductsLoadingState extends HomeStates {}

class HomeChangeCategoryState extends HomeStates {}

class HomeGetProductsSuccessState extends HomeStates {
  final List<ProductModel> products;
  HomeGetProductsSuccessState(this.products);
}

class HomeGetProductsErrorState extends HomeStates {
  final String errorMessage;
  HomeGetProductsErrorState(this.errorMessage);
}
