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
  ];
  int navBarCurrentIndex = 0;

  void changeNavBarIndex(int index) {
    navBarCurrentIndex = index;
    emit(HomeChangeNavBarIndexState());
  }

  Future<void> getAllHomeData() async {
    emit(HomeGetProductsLoadingState());

    await Future.wait([getProducts(), getWishlist(), getCart()]);

    syncProductsWithWishlist();
  }

  Future<void> getProducts() async {
    final products = await _homeRepository.getProducts();
    products.fold((error) => emit(HomeGetProductsErrorState(error)), (
      products,
    ) {
      productsList = products;
      getCategories();
    });
  }

  void getCategories() {
    final categories = productsList
        .map((product) => product.category)
        .toSet()
        .toList();
    categoriesList.addAll(categories);
  }

  Future<void> getCart() async {
    final products = await _homeRepository.getCart();
    products.fold((error) => emit(HomeAddToCartErrorState(error)), (products) {
      cartList = products;
    });
  }

  void selectCategory(int index) {
    currentCategoryIndex = index;
    filterProducts();
    emit(HomeChangeCategoryState());
  }

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
  }

  Future<void> addToCart(ProductModel product) async {
    final cart = await _homeRepository.addToCart(product);
    cart.fold(
      (r) => emit(HomeAddToCartErrorState(r)),
      (l) => emit(HomeAddToCartSuccessState()),
    );
  }

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
  }

  Future<void> toggleCartlist(ProductModel product) async {
    final result = await _homeRepository.addToCart(product);

    result.fold((error) => emit(HomeAddToCartErrorState(error)), (success) {
      if (cartList.any((element) => element.id == product.id)) {
        cartList.removeWhere((element) => element.id == product.id);
        _homeRepository.deleteFromCart(product.id);
      } else {
        wishList.add(product);
      }
      emit(HomeAddToCartSuccessState());
    });
  }

  Future<void> getWishlist() async {
    emit(GetWishlistLoading());
    final result = await _homeRepository.getWishList();
    result.fold((r) => emit(GetWishlistError(r)), (data) {
      wishList = data;
      emit(GetWishlistSuccess(data));
    });
  }

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
  }
}
