import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/feature/home/data/models/cart_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final FormState status;
  final int currentCategoryIndex;
  final int navBarCurrentIndex;
  final List<ProductModel> products;
  final List<ProductModel> wishList;
  final List<ProductModel> cartList;
  final List<String> categoriesList;
  final CartModel cartModel;
  const HomeState({
    this.status = const FormInitialState(),
    this.currentCategoryIndex = 0,
    this.navBarCurrentIndex = 0,
    this.products = const [],
    this.categoriesList = const [],
    this.wishList = const [],
    this.cartList = const [],
    this.cartModel = const CartModel(
      discount: 0,
      subtotal: 0,
      tax: 0,
      total: 0,
    ),
  });

  HomeState copyWith({
    FormState? status,
    int? currentCategoryIndex,
    int? navBarCurrentIndex,
    List<ProductModel>? products,
    List<String>? categoriesList,
    List<ProductModel>? wishList,
    List<ProductModel>? cartList,
    CartModel? cartModel,
  }) {
    return HomeState(
      status: status ?? this.status,
      currentCategoryIndex: currentCategoryIndex ?? this.currentCategoryIndex,
      navBarCurrentIndex: navBarCurrentIndex ?? this.navBarCurrentIndex,
      products: products ?? this.products,
      categoriesList: categoriesList ?? this.categoriesList,
      wishList: wishList ?? this.wishList,
      cartList: cartList ?? this.cartList,
      cartModel: cartModel ?? this.cartModel,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentCategoryIndex,
    navBarCurrentIndex,
    products,
    categoriesList,
    wishList,
    cartList,
    cartModel,
  ];
}

abstract class FormState extends Equatable {
  const FormState();
}

class FormInitialState extends FormState {
  const FormInitialState();
  @override
  List<Object?> get props => [];
}

class FormLoadingState extends FormState {
  @override
  List<Object?> get props => [];
}

class FormSuccessState extends FormState {
  const FormSuccessState();

  @override
  List<Object?> get props => [];
}

class FormFailureState extends FormState {
  final String message;
  const FormFailureState(this.message);

  @override
  List<Object?> get props => [message];
}

class AddToCartSuccessState extends FormState {
  const AddToCartSuccessState();
  @override
  List<Object?> get props => [];
}

class AddToCartErrorState extends FormState {
  final String message;
  const AddToCartErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class FormGetProductsSuccess extends FormState {
  final List<ProductModel> products;
  const FormGetProductsSuccess(this.products);
  @override
  List<Object?> get props => [products];
}
