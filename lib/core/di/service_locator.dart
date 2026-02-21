import 'package:dio/dio.dart';
import 'package:e_commerce/core/database/remote/networking/api_constant.dart';
import 'package:e_commerce/core/database/remote/networking/dio_helper.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/feature/auth/data/data_scource/auth_data_source.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

void setupSecureStorageLocator() {
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
  getIt.registerLazySingleton<SecureStorageHelper>(
    () => SecureStorageHelper(getIt<FlutterSecureStorage>()),
  );
}

void setupAuthRepositoryLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
}
