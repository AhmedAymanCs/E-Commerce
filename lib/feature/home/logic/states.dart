import 'package:e_commerce/feature/home/data/models/product_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeChangeNavBarIndexState extends HomeStates {}

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

class HomeAddToCartSuccessState extends HomeStates {}

class HomeAddToCartErrorState extends HomeStates {
  final String errorMessage;
  HomeAddToCartErrorState(this.errorMessage);
}

class HomeAddToWishListSuccessState extends HomeStates {}

class HomeAddToWishListErrorState extends HomeStates {
  final String errorMessage;
  HomeAddToWishListErrorState(this.errorMessage);
}

class GetWishlistLoading extends HomeStates {}

class GetWishlistSuccess extends HomeStates {
  final List<ProductModel> wishlist;
  GetWishlistSuccess(this.wishlist);
}

class GetWishlistError extends HomeStates {
  final String message;
  GetWishlistError(this.message);
}

class HomeDeleteCartSuccessState extends HomeStates {}

class HomeDeleteCartErrorState extends HomeStates {
  final String message;

  HomeDeleteCartErrorState(this.message);
}
