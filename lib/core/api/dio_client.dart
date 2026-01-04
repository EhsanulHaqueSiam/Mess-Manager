import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

/// Dio client configuration with interceptors
class DioClient {
  static Dio? _dio;
  static ApiClient? _apiClient;

  /// Get configured Dio instance
  static Dio get dio {
    _dio ??= _createDio();
    return _dio!;
  }

  /// Get API client
  static ApiClient get api {
    _apiClient ??= ApiClient(dio);
    return _apiClient!;
  }

  /// Create and configure Dio
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        // Note: For Firebase backend, use Cloud Functions URL
        // For now, this is a placeholder
        baseUrl: 'https://api.example.com/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      // Logging interceptor (debug only)
      if (kDebugMode)
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),

      // Error handling interceptor
      InterceptorsWrapper(
        onError: (error, handler) {
          // Log error
          debugPrint('API Error: ${error.message}');
          debugPrint('Request: ${error.requestOptions.path}');

          // Handle specific error codes
          if (error.response?.statusCode == 401) {
            // Unauthorized - redirect to login
            debugPrint('Unauthorized access - need to re-authenticate');
          }

          handler.next(error);
        },
      ),

      // Retry interceptor
      _RetryInterceptor(dio),
    ]);

    return dio;
  }

  /// Reset Dio instance (useful for logout)
  static void reset() {
    _dio = null;
    _apiClient = null;
  }

  /// Set auth token
  static void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove auth token
  static void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}

/// Retry interceptor for failed requests
class _RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  _RetryInterceptor(this.dio, {this.maxRetries = 3});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry on specific errors
    if (_shouldRetry(err) && _getRetryCount(err) < maxRetries) {
      try {
        // Wait before retry (exponential backoff)
        final retryCount = _getRetryCount(err);
        await Future.delayed(Duration(milliseconds: 300 * (retryCount + 1)));

        // Retry request
        final options = err.requestOptions;
        options.extra['retryCount'] = retryCount + 1;

        final response = await dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        // Failed to retry, pass error
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }

  int _getRetryCount(DioException err) {
    return err.requestOptions.extra['retryCount'] as int? ?? 0;
  }
}
