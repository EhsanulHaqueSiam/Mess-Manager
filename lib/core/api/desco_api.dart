import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'desco_api.g.dart';

/// DESCO Prepaid Meter API Client
/// Uses Retrofit for clean API definitions
@RestApi(baseUrl: 'https://prepaid.desco.org.bd/api')
abstract class DescoApi {
  factory DescoApi(Dio dio, {String baseUrl}) = _DescoApi;

  /// Get customer info by account or meter number
  /// accountNo = 8 digits, meterNo = 12 digits
  @GET('/tkdes/customer/getCustomerInfo')
  Future<DescoApiResponse> getCustomerInfo({
    @Query('accountNo') String? accountNo,
    @Query('meterNo') String? meterNo,
  });

  /// Get current balance
  @GET('/tkdes/customer/getBalance')
  Future<DescoApiResponse> getBalance(
    @Query('accountNo') String accountNo,
    @Query('meterNo') String meterNo,
  );

  /// Get monthly consumption for a year range
  @GET('/tkdes/customer/getCustomerMonthlyConsumption')
  Future<DescoApiResponse> getMonthlyConsumption(
    @Query('accountNo') String accountNo,
    @Query('meterNo') String meterNo,
    @Query('monthFrom') String monthFrom, // Format: YYYY-MM
    @Query('monthTo') String monthTo, // Format: YYYY-MM
  );

  /// Get recharge history
  @GET('/tkdes/customer/getRechargeHistory')
  Future<DescoApiResponse> getRechargeHistory(
    @Query('accountNo') String accountNo,
    @Query('meterNo') String meterNo,
    @Query('dateFrom') String dateFrom, // Format: YYYY-MM-DD
    @Query('dateTo') String dateTo, // Format: YYYY-MM-DD
  );

  /// Get customer location
  @GET('/common/getCustomerLocation')
  Future<DescoApiResponse> getCustomerLocation(
    @Query('accountNo') String accountNo,
  );
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

  bool get isSuccess => data != null;
}
