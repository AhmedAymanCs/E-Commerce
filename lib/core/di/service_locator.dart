import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/database/remote/networking/api_constant.dart';
import 'package:e_commerce/core/database/remote/networking/dio_helper.dart';
import 'package:e_commerce/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:e_commerce/core/stripe_payment/payment_manager.dart';
import 'package:e_commerce/core/stripe_payment/stripe_keys.dart';
import 'package:e_commerce/feature/auth/data/data_source/auth_data_source.dart';
import 'package:e_commerce/feature/auth/data/repository/auth_repository.dart';
import 'package:e_commerce/feature/checkout/data/data_source/checkout_source.dart';
import 'package:e_commerce/feature/checkout/data/repository/repository.dart';
import 'package:e_commerce/feature/home/data/data_source/data_source.dart';
import 'package:e_commerce/feature/home/data/repository/repository.dart';
import 'package:e_commerce/feature/orders_history/data/data_source/data_source.dart';
import 'package:e_commerce/feature/orders_history/data/repository/repositroy.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void servicesLocatorInit() {
  _setupDioLocator();
  _setupSecureStorageLocator();
  _setupAuthRepositoryLocator();
  _setupFirestoreLocator();
  _setupStripeLocator();
}

void _setupDioLocator() {
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

void _setupSecureStorageLocator() {
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

void _setupAuthRepositoryLocator() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<FirebaseAuth>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: getIt<AuthRemoteDataSource>(),
      firestore: getIt<FirebaseFirestore>(),
      secureStorageHelper: getIt<SecureStorageHelper>(),
    ),
  );
}

void _setupFirestoreLocator() {
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      getIt<DioHelper>(),
      getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );

  getIt.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<CheckoutRepo>(
    () => CheckoutRepoImpl(
      remoteDataSource: getIt<CheckoutRemoteDataSource>(),
      paymentManager: getIt<PaymentManager>(),
    ),
  );
  getIt.registerLazySingleton<OrdersHistoryRemoteDataSource>(
    () => OrdersHistoryRemoteDataSourceImpl(
      getIt<FirebaseFirestore>(),
      getIt<SecureStorageHelper>(),
    ),
  );
  getIt.registerLazySingleton<OrdersHistoryRepository>(
    () => OrdersHistoryRepositoryImpl(getIt<OrdersHistoryRemoteDataSource>()),
  );
}

void _setupStripeLocator() {
  Stripe.publishableKey = ApiKeys.publishableKey;
  getIt.registerLazySingleton<PaymentManager>(
    () => PaymentManager(getIt<Dio>()),
  );
}
