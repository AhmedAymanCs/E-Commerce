import 'package:dio/dio.dart';
import 'package:e_commerce/core/database/remote/networking/api_constant.dart';
import 'package:e_commerce/core/database/remote/networking/dio_helper.dart';

abstract class HomeRemoteDataSource {
  Future<Response> getProducts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioHelper _dio;

  HomeRemoteDataSourceImpl(this._dio);
  @override
  Future<Response> getProducts() async {
    return _dio.getData(endPoint: ApiConstant.productEndPoint);
  }
}
