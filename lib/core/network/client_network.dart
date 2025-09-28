import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

typedef AuthHeaderProvider = String? Function();

class ClientNetwork {
  late final Dio _dio;
  final String _host;

  ClientNetwork({
    String? host,
  }) : _host = host ?? 'http://127.0.0.1:3000/api' {
    _dio = Dio();
    _dio
      ..options.baseUrl = _host
      ..options.connectTimeout = const Duration(milliseconds: 15000)
      ..interceptors.add(PrettyDioLogger(
          compact: false, logPrint: (object) => log(object.toString())));
  }

  String _buildUrl(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    final url = '$_host/$path';

    return url;
  }

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? headers}) {
    return _dio.get<T>(_buildUrl(path),
        queryParameters: queryParams, options: Options(headers: headers));
  }

  Future<Response<T>> post<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) {
    return _dio.post(_buildUrl(path),
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers));
  }

  Future<Response<T>> put<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) {
    return _dio.put(_buildUrl(path),
        queryParameters: queryParams,
        data: data,
        options: Options(headers: headers));
  }

  Future<Response<T>> delete<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) {
    return _dio.delete(_buildUrl(path),
        data: data,
        queryParameters: queryParams,
        options: Options(headers: headers));
  }
}
