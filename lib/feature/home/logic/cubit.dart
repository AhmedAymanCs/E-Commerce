import 'package:e_commerce/core/utils/extensions.dart';
import 'package:e_commerce/feature/home/data/models/cart_model.dart';
import 'package:e_commerce/feature/home/data/models/product_model.dart';
import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/feature/home/data/repository/repository.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:e_commerce/feature/home/presentation/cart/cart_screen.dart';
import 'package:e_commerce/feature/home/presentation/home/home_screen.dart';
import 'package:e_commerce/feature/home/presentation/wish_list/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository _homeRepository;
  final UserModel userModel;
  HomeCubit(this._homeRepository, this.userModel) : super(HomeInitialState());

  // ignore: strict_top_level_inference
  static HomeCubit get(context) => BlocProvider.of(context);

  List<ProductModel> productsList = [];
  List<String> categoriesList = ['All'];
  List<ProductModel> wishList = [];
  List<ProductModel> cartList = [];

  int currentCategoryIndex = 0;

  List<Widget> get pages => [
    HomePage(userModel: userModel),
    const WishlistPage(),
    const CartPage(),
  ]; //initialize bottom navigation bar pages
  int navBarCurrentIndex = 0; //initialize nav bar index
  CartModel cartModel = CartModel(
    discount: 0,
    subtotal: 0,
    tax: 0,
    total: 0,
  ); //initialize cart model

  void changeNavBarIndex(int index) {
    navBarCurrentIndex = index;
    emit(HomeChangeNavBarIndexState());
  } //changeNavBarIndex method

  ///////////// home methods ///////////////////
  Future<void> getAllHomeData() async {
    emit(HomeGetProductsLoadingState());

    await Future.wait([getProducts(), getWishlist(), getCart()]);

    syncProductsWithWishlist();
  } //getAllHomeData method (get all data from home repository) in frist open app

  Future<void> getProducts() async {
    final products = await _homeRepository.getProducts();
    products.fold((error) => emit(HomeGetProductsErrorState(error)), (
      products,
    ) {
      productsList = products;
      getCategories();
    });
  } //getProducts method

  void getCategories() {
    final categories = productsList
        .map((product) => product.category)
        .toSet()
        .toList();
    categoriesList.addAll(categories);
  } //getCategories method

  void selectCategory(int index) {
    currentCategoryIndex = index;
    filterProducts();
    emit(HomeChangeCategoryState());
  } //selectCategory method

  void filterProducts() {
    emit(HomeGetProductsLoadingState());
    final products = productsList.where((product) {
      if (currentCategoryIndex == 0) {
        return true;
      } else {
        return product.category == categoriesList[currentCategoryIndex];
      }
    }).toList();
    emit(HomeGetProductsSuccessState(products));
  }

  //filterProducts method by category
  void searchProducts(String text) {
    emit(HomeGetProductsLoadingState());
    final products = productsList.where((product) {
      if (text.isEmpty) {
        return true;
      } else {
        return product.title.toLowerCase().contains(text.toLowerCase());
      }
    }).toList();
    emit(HomeGetProductsSuccessState(products));
  } //searchProducts method

  ///////////// wishlist methods ///////////////////

  Future<void> toggleWishlist(ProductModel product) async {
    final result = await _homeRepository.addToWishlist(product);

    result.fold((error) => emit(HomeAddToWishListErrorState(error)), (success) {
      if (wishList.any((element) => element.id == product.id)) {
        wishList.removeWhere((element) => element.id == product.id);
        _homeRepository.deleteFromWishList(product.id);
      } else {
        wishList.add(product);
      }
      syncProductsWithWishlist();
      emit(HomeAddToWishListSuccessState());
    });
  } //toggleWishlist (add / remove from wishlist)

  Future<void> getWishlist() async {
    emit(GetWishlistLoading());
    final result = await _homeRepository.getWishList();
    result.fold((r) => emit(GetWishlistError(r)), (data) {
      wishList = data;
      emit(GetWishlistSuccess(data));
    });
  } //getWishlist method

  void syncProductsWithWishlist() {
    final wishlistIds = wishList.map((item) => item.id).toSet();
    productsList = productsList.map((product) {
      if (wishlistIds.contains(product.id)) {
        return product.copyWith(isFavorite: true);
      } else {
        return product.copyWith(isFavorite: false);
      }
    }).toList();
    emit(HomeGetProductsSuccessState(productsList));
  } //syncProductsWithWishlist method

  ///////////// cart methods ///////////////////

  Future<void> addToCart(ProductModel product) async {
    final cart = await _homeRepository.addToCart(product);
    cartList.add(product);
    cart.fold(
      (r) => emit(HomeAddToCartErrorState(r)),
      (l) => emit(HomeAddToCartSuccessState()),
    );
  } //addToCart method

  Future<void> deleteCartlist(int productId) async {
    final cart = await _homeRepository.deleteFromCart(productId);
    cart.fold((r) => emit(HomeDeleteCartErrorState(r)), (l) {
      cartList.removeWhere((element) => element.id == productId);
      calculateCartModel();
      emit(HomeDeleteCartSuccessState());
    });
  } //deleteCartlist method

  Future<void> getCart() async {
    final products = await _homeRepository.getCart();
    products.fold((error) => emit(HomeAddToCartErrorState(error)), (products) {
      cartList = products;
    });
    calculateCartModel();
  } //getCart method

  void calculateCartModel() {
    final double subTotal = cartList.fold(
      0,
      (previousValue, product) => previousValue + product.price,
    );
    final double tax = subTotal * 0.14;
    final double discount = 0;
    final double total = subTotal + tax - discount;
    cartModel = CartModel(
      discount: 0,
      subtotal: subTotal.roundToTwo(),
      tax: tax.roundToTwo(),
      total: total.roundToTwo(),
    );
  }
}
