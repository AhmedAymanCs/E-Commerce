import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/models/product_model.dart';
import 'package:e_commerce/core/utils/typedef.dart';
import 'package:e_commerce/feature/home/data/data_source/data_source.dart';

abstract class HomeRepository {
  ServerResponse<List<ProductModel>> getProducts();
  ServerResponse<void> addToCart(ProductModel product);
  ServerResponse<void> addToWishlist(ProductModel product);
  ServerResponse<void> deleteFromWishList(int productId);
  ServerResponse<List<ProductModel>> getWishList();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;
  HomeRepositoryImpl(this._homeRemoteDataSource);

  @override
  ServerResponse<List<ProductModel>> getProducts() async {
    try {
      final response = await _homeRemoteDataSource.getProducts();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['products'];
        final List<ProductModel> products = data
            .map((product) => ProductModel.fromJson(product))
            .toList();
        return Right(products);
      } else {
        return Left("Server Error :${response.statusCode}");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> addToCart(ProductModel product) async {
    try {
      await _homeRemoteDataSource.addToCart(product);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> addToWishlist(ProductModel product) async {
    try {
      await _homeRemoteDataSource.addToWishlist(product);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<void> deleteFromWishList(int productId) async {
    try {
      await _homeRemoteDataSource.deleteFromWishList(productId);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  ServerResponse<List<ProductModel>> getWishList() async {
    try {
      final wishlist = await _homeRemoteDataSource.getWishlist();
      return Right(wishlist);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
