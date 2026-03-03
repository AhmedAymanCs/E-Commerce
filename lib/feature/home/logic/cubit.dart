import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/events/app_events.dart';
import 'package:e_commerce/core/routing/routes.dart';
import 'package:e_commerce/core/utils/extensions.dart';
import 'package:e_commerce/feature/home/data/models/cart_model.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/models/user_model.dart';
import 'package:e_commerce/feature/home/data/repository/repository.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;
  final UserModel? userModel;
  final SecureStorageHelper secureStorageHelper;
  HomeCubit({
    required this.homeRepository,
    this.userModel,
    required this.secureStorageHelper,
  }) : super(HomeState()) {
    eventBus.on<OrderConfirmedEvent>().listen((event) {
      clearCart();
    });
  }

  //initialize bottom navigation bar pages

  void changeNavBarIndex(int index) {
    emit(state.copyWith(navBarCurrentIndex: index, status: FormSuccessState()));
  } //changeNavBarIndex method

  ///////////// home methods ///////////////////
  Future<void> getAllHomeData() async {
    emit(state.copyWith(status: FormLoadingState()));

    await Future.wait([getProducts(), getWishlist(), getCart()]);
    syncProductsWithWishlist();
  } //getAllHomeData method (get all data from home repository) in frist open app

  Future<void> getProducts() async {
    final products = await homeRepository.getProducts();
    products.fold(
      (error) => emit(state.copyWith(status: FormFailureState(error))),
      (products) {
        emit(
          state.copyWith(
            products: products,
            status: FormGetProductsSuccess(products),
          ),
        );
        getCategories();
      },
    );
  } //getProducts method

  void getCategories() {
    final categories = state.products
        .map((product) => product.category)
        .toSet()
        .toList();
    emit(state.copyWith(categoriesList: ['All', ...categories]));
  } //getCategories method

  void selectCategory(int index) {
    emit(
      state.copyWith(currentCategoryIndex: index, status: FormSuccessState()),
    );
    filterProducts();
  } //selectCategory method

  void filterProducts() {
    final wishlistIds = state.wishList.map((item) => item.id).toSet();
    final products = state.products
        .where((product) {
          if (state.currentCategoryIndex == 0) {
            return true;
          } else {
            return product.category ==
                state.categoriesList[state.currentCategoryIndex];
          }
        })
        .map(
          (product) =>
              product.copyWith(isFavorite: wishlistIds.contains(product.id)),
        )
        .toList();

    emit(state.copyWith(status: FormGetProductsSuccess(products)));
  } //filterProducts method by category

  void searchProducts(String text) {
    emit(state.copyWith(status: FormLoadingState()));
    final products = state.products.where((product) {
      if (text.isEmpty) {
        return true;
      } else {
        return product.title.toLowerCase().contains(text.toLowerCase());
      }
    }).toList();
    emit(state.copyWith(status: FormGetProductsSuccess(products)));
  } //searchProducts method

  ///////////// wishlist methods ///////////////////

  Future<void> toggleWishlist(ProductModel product) async {
    final isInWishlist = state.wishList.any((e) => e.id == product.id);
    if (isInWishlist) {
      final result = await homeRepository.deleteFromWishList(product.id);
      result.fold(
        (error) => emit(state.copyWith(status: FormFailureState(error))),
        (_) {
          emit(
            state.copyWith(
              wishList: state.wishList
                  .where((e) => e.id != product.id)
                  .toList(),
            ),
          );
        },
      );
    } else {
      final result = await homeRepository.addToWishlist(product);
      result.fold(
        (error) => emit(state.copyWith(status: FormFailureState(error))),
        (_) {
          emit(state.copyWith(wishList: [...state.wishList, product]));
        },
      );
    }
    syncProductsWithWishlist(toggle: true);
  } //toggleWishlist (add / remove from wishlist)

  Future<void> getWishlist() async {
    emit(state.copyWith(status: FormLoadingState()));
    final result = await homeRepository.getWishList();
    result.fold(
      (error) => emit(state.copyWith(status: FormFailureState(error))),
      (data) {
        emit(state.copyWith(wishList: data));
      },
    );
  } //getWishlist method

  void syncProductsWithWishlist({bool toggle = false}) {
    final wishlistIds = state.wishList.map((item) => item.id).toSet();

    if (toggle) {
      final currentProducts = state.status is FormGetProductsSuccess
          ? (state.status as FormGetProductsSuccess).products
          : state.products;
      final productsList = currentProducts.map((product) {
        return product.copyWith(isFavorite: wishlistIds.contains(product.id));
      }).toList();

      emit(state.copyWith(status: FormGetProductsSuccess(productsList)));
    } else {
      final productsList = state.products.map((product) {
        if (wishlistIds.contains(product.id)) {
          return product.copyWith(isFavorite: true);
        } else {
          return product.copyWith(isFavorite: false);
        }
      }).toList();
      emit(
        state.copyWith(
          products: productsList,
          status: FormGetProductsSuccess(productsList),
        ),
      );
    }
  } //syncProductsWithWishlist method

  ///////////// cart methods ///////////////////

  Future<void> addToCart(ProductModel product) async {
    final cart = await homeRepository.addToCart(product);
    int index = state.cartList.indexWhere(
      (element) => element.id == product.id,
    );

    if (index != -1) {
      updateQuantityInCart(
        productId: product.id,
        quantity: product.quantity,
        addQuantity: true,
      );
    } else {
      emit(state.copyWith(cartList: [...state.cartList, product]));
    }
    cart.fold(
      (error) => emit(state.copyWith(status: AddToCartErrorState(error))),
      (l) {
        calculateCartModel();
        emit(state.copyWith(status: AddToCartSuccessState()));
      },
    );
  } //addToCart method

  Future<void> deleteCartlist(int productId) async {
    final cart = await homeRepository.deleteFromCart(productId);
    cart.fold(
      (error) => emit(state.copyWith(status: FormFailureState(error))),
      (l) {
        final itemIndex = state.cartList.indexWhere((e) => e.id == productId);
        if (itemIndex != -1) {
          final updatedCartList = state.cartList;
          updatedCartList[itemIndex].quantity = 1;
          updatedCartList.removeAt(itemIndex);
          emit(state.copyWith(cartList: updatedCartList));
        }
        calculateCartModel();
      },
    );
  } //deleteCartlist method

  Future<void> getCart() async {
    final products = await homeRepository.getCart();
    products.fold(
      (error) => emit(state.copyWith(status: FormFailureState(error))),
      (products) {
        emit(state.copyWith(cartList: products));
      },
    );

    calculateCartModel();
  } //getCart method

  void calculateCartModel() {
    final double subTotal = state.cartList.fold(
      0,
      (previousValue, product) =>
          (previousValue + product.price) * product.quantity,
    );
    final double tax = subTotal * 0.14;
    final double discount = 0;
    final double total = subTotal + tax - discount;

    emit(
      state.copyWith(
        cartModel: CartModel(
          discount: 0,
          subtotal: subTotal.roundToTwo(),
          tax: tax.roundToTwo(),
          total: total.roundToTwo(),
        ),
      ),
    );
  }

  Future<void> updateQuantityInCart({
    required int productId,
    required int quantity,
    bool addQuantity = true,
  }) async {
    if (quantity >= 1) {
      addQuantity
          ? quantity++
          : quantity == 1
          ? quantity
          : quantity--;
      final product = await homeRepository.updateQuantityInCart(
        productId,
        quantity,
      );
      int index = state.cartList.indexWhere(
        (element) => element.id == productId,
      );
      product.fold(
        (error) => emit(state.copyWith(status: FormFailureState(error))),
        (l) {
          final updatedCartList = state.cartList;
          updatedCartList[index].quantity = quantity;
          emit(state.copyWith(cartList: updatedCartList));
          calculateCartModel();
          emit(state.copyWith(status: FormSuccessState()));
        },
      );
    }
  }

  Future<void> clearCart() async {
    for (var product in state.cartList) {
      product.quantity = 1;
    }
    emit(state.copyWith(cartList: []));
    await homeRepository.clearCart();
    emit(
      state.copyWith(
        cartModel: CartModel(discount: 0, subtotal: 0, tax: 0, total: 0),
      ),
    );
    emit(state.copyWith(status: FormSuccessState()));
  }

  // ignore: strict_top_level_inference
  Future<void> signOut(context) async {
    homeRepository
        .signOut()
        .then((_) {
          secureStorageHelper.clearAll();
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.loginRoute,
            (_) => false,
          );
        })
        .catchError((e) {});
  }
}
