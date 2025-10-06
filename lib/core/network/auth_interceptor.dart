import 'package:dio/dio.dart';
import 'package:lotus_news_web/core/utils/app_logger.dart';

import 'package:lotus_news_web/features/auth/domain/repositories/token_storage_repository.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorageRepository _tokenStorageRepository;

  AuthInterceptor({required TokenStorageRepository tokenStorageRepository})
    : _tokenStorageRepository = tokenStorageRepository;

  // Track which requests are currently being retried to prevent infinite loops
  final Set<String> _retryingRequests = <String>{};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (_isAuthEndpoint(options.path)) {
        return handler.next(options);
      }

      final authHeader = await _tokenStorageRepository.getAuthorizationHeader();
      if (authHeader != null) {
        // options.headers['Content-type'] = 'application/json';
        options.headers['Authorization'] = authHeader;
      } else {
        logger.t(
          'AuthInterceptor [onRequest]: No auth token available for request: ${options.uri}',
        );
      }

      handler.next(options);
    } catch (e) {
      logger.e('AutInterceptor [onRequest]: $e');
      return handler.next(options);
    }
  }

  @override
  onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.t(
      'AuthInterceptor [onResponse]: Response received: [${response.statusCode}] ${response.requestOptions.uri}',
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    logger.e(
      'AuthInterceptor [onError]: [${err.response?.statusCode}] ${err.requestOptions.uri}',
    );

    /// Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      logger.i('Handling 401 Unauthorized error');

      // Skip refresh for auth endpoints to prevent infinite loops
      if (_isAuthEndpoint(err.requestOptions.path)) {
        logger.i('Skipping token refresh for auth endpoint');
      }

      final requestKey =
          '${err.requestOptions.method}_${err.requestOptions.uri}';

      // Check if we're already retrying this request
      if (_retryingRequests.contains(requestKey)) {
        logger.d(
          'AuthInterceptor [onError]: retrying request, skipping: $requestKey',
        );
        return handler.next(err);
      }

      try {
        // Mark this request as being retried
        _retryingRequests.add(requestKey);
      } catch (retryError) {
        return handler.next(err);
      } finally {
        _retryingRequests.remove(requestKey);
      }
    }
    return handler.next(err);
  }

  bool _isAuthEndpoint(String path) {
    final authPaths = ['/api/login', '/api/refresh', '/api/logout'];

    return authPaths.any((authPath) => path.contains(authPath));
  }
}
