import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/feature/home/data/repository/repository.dart';
import 'package:e_commerce/feature/home/logic/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository _homeRepository;
  HomeCubit(this._homeRepository) : super(HomeInitialState());

  // ignore: strict_top_level_inference
  static HomeCubit get(context) => BlocProvider.of(context);
  List<ProductModel> productsList = [];
  List<String> categoriesList = ['All'];
  int currentCategoryIndex = 0;
  Future<void> getProducts() async {
    emit(HomeGetProductsLoadingState());
    final products = await _homeRepository.getProducts();
    products.fold((error) => emit(HomeGetProductsErrorState(error)), (
      products,
    ) {
      productsList = products;
      getCategories();
      emit(HomeGetProductsSuccessState(products));
    });
  }

  void getCategories() {
    final categories = productsList
        .map((product) => product.category)
        .toSet()
        .toList();
    categoriesList.addAll(categories);
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

  Future<void> addToWishlist(ProductModel product) async {
    final wishList = await _homeRepository.addToWishlist(product);
    wishList.fold(
      (r) => emit(HomeAddToWishListErrorState(r)),
      (l) => emit(HomeAddToWishListSuccessState()),
    );
  }
}
