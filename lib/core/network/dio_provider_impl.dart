import 'package:dio/dio.dart';
import '../../../../core/network/network.dart';
import '../../../../env/flavor_config.dart';
import 'dart:developer';
class DioProviderImpl implements ApiManager {
  static final String baseUrl = FlavorConfig.instance.values.baseUrl;

  

  static Dio dioClient = _addInterceptors(_createDio());

  static Dio _createDio() {
    log("--baseUrl:$baseUrl");
    BaseOptions opts = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
    );
    return Dio(opts);
  }

  static Dio _addInterceptors(Dio dio) {

    dio.interceptors.add(InterceptorsWrapper(onRequest: (
      RequestOptions options,
      RequestInterceptorHandler handler,
    ) {
      return handler.next(options); //continue
    }, onResponse: (response, ResponseInterceptorHandler handler) {
      return handler.next(response); // continue
    }, onError: (DioException error, ErrorInterceptorHandler handler) async {
      // String? e = DioErrorHandler.dioErrorToString(error);
      //debugPrint(e);
      return handler.next(error);
    }));

    return dio;
  }

  @override
  Future<Response> get(String url,
      {Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await dioClient.get(url,
          queryParameters: queryParams, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      //debugPrint('dio get error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
        // throw Exception(e);
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<Response> getUri(Uri url, {Map<String, dynamic>? headers}) async {
    try {
      final response =
          await dioClient.getUri(url, options: Options(headers: headers));
      return response;
    } on DioException catch (e) {
      //debugPrint('dio get error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
        // throw Exception(e);
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<Response> post(String url,
      {Map<String, dynamic>? headers, body, encoding}) async {
    try {
      final response = await dioClient.post(url,
          data: body, options: Options(headers: headers));

      return response;
    } on DioException catch (e) {
      //debugPrint('dio post error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
        // throw Exception(e);
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<Response> delete(String url,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final Response response =
          await dioClient.delete(url, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      //debugPrint('dio error $e');
      if (e.response != null && e.response!.data != null) {
        return e.response!;
        // throw Exception(e);
      } else {
        throw ServerException();
      }
    }
  }
}
