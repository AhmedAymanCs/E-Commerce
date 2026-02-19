import 'package:dio/dio.dart';
import 'package:e_commerce/core/networking/api_constant.dart';
import 'package:e_commerce/core/networking/dio_helper.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void setupDioLocator() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiConstant.baseUrl,
        receiveTimeout: const Duration(seconds: ApiConstant.receiveTimeout),
        connectTimeout: const Duration(seconds: ApiConstant.connectTimeout),
        headers: ApiConstant.headers,
      ),
    ),
  );
  getIt.registerLazySingleton<DioHelper>(() => DioHelper(getIt<Dio>()));
}
