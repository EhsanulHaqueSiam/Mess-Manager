import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// DESCO Prepaid Meter API Client
/// Uses plain Dio for HTTP requests
class DescoApi {
  final Dio _dio;

  DescoApi(Dio dio) : _dio = dio {
    _dio.options.baseUrl = 'https://prepaid.desco.org.bd/api';

    // DESCO's SSL cert chain is incomplete — trust their domain explicitly
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) =>
          host.endsWith('desco.org.bd');
      return client;
    };
  }

  /// Get customer info by account or meter number
  /// accountNo = 8 digits, meterNo = 12 digits
  Future<DescoApiResponse> getCustomerInfo({
    String? accountNo,
    String? meterNo,
  }) async {
    final response = await _dio.get(
      '/tkdes/customer/getCustomerInfo',
      queryParameters: {
        if (accountNo != null) 'accountNo': accountNo,
        if (meterNo != null) 'meterNo': meterNo,
      },
    );
    return DescoApiResponse.fromJson(response.data);
  }

  /// Get current balance
  Future<DescoApiResponse> getBalance(
    String accountNo,
    String meterNo,
  ) async {
    final response = await _dio.get(
      '/tkdes/customer/getBalance',
      queryParameters: {
        'accountNo': accountNo,
        'meterNo': meterNo,
      },
    );
    return DescoApiResponse.fromJson(response.data);
  }

  /// Get monthly consumption for a year range
  Future<DescoApiResponse> getMonthlyConsumption(
    String accountNo,
    String meterNo,
    String monthFrom, // Format: YYYY-MM
    String monthTo, // Format: YYYY-MM
  ) async {
    final response = await _dio.get(
      '/tkdes/customer/getCustomerMonthlyConsumption',
      queryParameters: {
        'accountNo': accountNo,
        'meterNo': meterNo,
        'monthFrom': monthFrom,
        'monthTo': monthTo,
      },
    );
    return DescoApiResponse.fromJson(response.data);
  }

  /// Get recharge history
  Future<DescoApiResponse> getRechargeHistory(
    String accountNo,
    String meterNo,
    String dateFrom, // Format: YYYY-MM-DD
    String dateTo, // Format: YYYY-MM-DD
  ) async {
    final response = await _dio.get(
      '/tkdes/customer/getRechargeHistory',
      queryParameters: {
        'accountNo': accountNo,
        'meterNo': meterNo,
        'dateFrom': dateFrom,
        'dateTo': dateTo,
      },
    );
    return DescoApiResponse.fromJson(response.data);
  }

  /// Get daily consumption data (day-by-day usage)
  Future<DescoApiResponse> getDailyConsumption(
    String accountNo,
    String meterNo,
    String dateFrom, // Format: YYYY-MM-DD
    String dateTo, // Format: YYYY-MM-DD
  ) async {
    final response = await _dio.get(
      '/tkdes/customer/getCustomerDailyConsumption',
      queryParameters: {
        'accountNo': accountNo,
        'meterNo': meterNo,
        'dateFrom': dateFrom,
        'dateTo': dateTo,
      },
    );
    return DescoApiResponse.fromJson(response.data);
  }

  /// Get minimum recharge amount
  Future<DescoApiResponse> getMinRecharge(
    String accountNo,
    String meterNo,
  ) async {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://smartprepaid.desco.org.bd',
      connectTimeout: _dio.options.connectTimeout,
      receiveTimeout: _dio.options.receiveTimeout,
    ));
    final response = await dio.get(
      '/PrePay/v1/customer/min/recharge',
      queryParameters: {
        'accountNo': accountNo,
        'meterNo': meterNo,
      },
    );
    return DescoApiResponse.fromJson(response.data);
  }

  /// Get customer location
  Future<DescoApiResponse> getCustomerLocation(
    String accountNo,
  ) async {
    final response = await _dio.get(
      '/common/getCustomerLocation',
      queryParameters: {
        'accountNo': accountNo,
      },
    );
    return DescoApiResponse.fromJson(response.data);
  }
}

/// Generic API response wrapper for DESCO
class DescoApiResponse {
  final dynamic data;
  final String? message;
  final int? code;

  DescoApiResponse({this.data, this.message, this.code});

  factory DescoApiResponse.fromJson(Map<String, dynamic> json) {
    return DescoApiResponse(
      data: json['data'],
      message: json['message']?.toString(),
      code: json['code'],
    );
  }

  bool get isSuccess => data != null && (code == null || code == 200);
}
