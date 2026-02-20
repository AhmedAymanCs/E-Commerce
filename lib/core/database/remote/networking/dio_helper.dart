import 'package:dio/dio.dart';

class DioHelper {
  final Dio _dio;

  DioHelper(this._dio);

  Future<Response> getData({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(endPoint, queryParameters: queryParameters);
  }
}
