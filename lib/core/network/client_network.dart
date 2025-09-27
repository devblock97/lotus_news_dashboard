import 'package:dio/dio.dart';

typedef AuthHeaderProvider = String? Function();

class ClientNetwork {
  final Dio _dio;
  final String _host;

  ClientNetwork({String? host, Dio? dio})
    : _host = host ?? 'http://127.0.0.1:3000/api',
    _dio = dio ?? Dio() {
    _dio.options.followRedirects = true;
    _dio.options.maxRedirects = 5;
  }

  String _buildUrl(String path) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    final url = '$_host/$path';

    return url;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers}) {

    return _dio.get<T>(
        _buildUrl(path),
        queryParameters: queryParams,
        options: Options(headers: headers)
    );
  }

  Future<Response<T>> post<T>(
    String path, {
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) {

    return _dio.post(
        _buildUrl(path),
        queryParameters: queryParams,
        options: Options(headers: headers)
    );
  }

  Future<Response<T>> put<T>(
      String path, {
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? headers}) {

    return _dio.put(
        _buildUrl(path),
        queryParameters: queryParams,
        options: Options(headers: headers)
    );
  }
}