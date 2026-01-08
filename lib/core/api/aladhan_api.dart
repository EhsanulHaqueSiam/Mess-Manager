import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'aladhan_api.g.dart';

/// Aladhan Prayer Times API Client
/// Uses Retrofit for clean API definitions
@RestApi(baseUrl: 'https://api.aladhan.com/v1')
abstract class AladhanApi {
  factory AladhanApi(Dio dio, {String baseUrl}) = _AladhanApi;

  /// Get prayer times by coordinates for a specific date
  /// [date] format: DD-MM-YYYY
  /// [method] calculation method (1 = University of Islamic Sciences, Karachi)
  @GET('/timings/{date}')
  Future<AladhanResponse> getTimingsByCoordinates(
    @Path('date') String date,
    @Query('latitude') double latitude,
    @Query('longitude') double longitude, {
    @Query('method') int method = 1,
  });

  /// Get prayer times by city name
  @GET('/timingsByCity/{date}')
  Future<AladhanResponse> getTimingsByCity(
    @Path('date') String date,
    @Query('city') String city,
    @Query('country') String country, {
    @Query('method') int method = 1,
  });
}

/// API Response wrapper
class AladhanResponse {
  final int code;
  final String status;
  final AladhanData? data;

  AladhanResponse({required this.code, required this.status, this.data});

  factory AladhanResponse.fromJson(Map<String, dynamic> json) {
    return AladhanResponse(
      code: json['code'] ?? 0,
      status: json['status'] ?? '',
      data: json['data'] != null ? AladhanData.fromJson(json['data']) : null,
    );
  }
}

class AladhanData {
  final AladhanTimings timings;
  final AladhanDate date;
  final AladhanMeta meta;

  AladhanData({required this.timings, required this.date, required this.meta});

  factory AladhanData.fromJson(Map<String, dynamic> json) {
    return AladhanData(
      timings: AladhanTimings.fromJson(json['timings'] ?? {}),
      date: AladhanDate.fromJson(json['date'] ?? {}),
      meta: AladhanMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class AladhanTimings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;

  AladhanTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
  });

  factory AladhanTimings.fromJson(Map<String, dynamic> json) {
    String cleanTime(String? time) => (time ?? '00:00').split(' ').first;
    return AladhanTimings(
      fajr: cleanTime(json['Fajr']),
      sunrise: cleanTime(json['Sunrise']),
      dhuhr: cleanTime(json['Dhuhr']),
      asr: cleanTime(json['Asr']),
      sunset: cleanTime(json['Sunset']),
      maghrib: cleanTime(json['Maghrib']),
      isha: cleanTime(json['Isha']),
    );
  }

  /// Sehri end time (Fajr)
  String get sehriEnd => fajr;

  /// Iftar time (Maghrib)
  String get iftarTime => maghrib;
}

class AladhanDate {
  final String readable;
  final String timestamp;

  AladhanDate({required this.readable, required this.timestamp});

  factory AladhanDate.fromJson(Map<String, dynamic> json) {
    return AladhanDate(
      readable: json['readable'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class AladhanMeta {
  final double latitude;
  final double longitude;
  final String timezone;

  AladhanMeta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory AladhanMeta.fromJson(Map<String, dynamic> json) {
    return AladhanMeta(
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      timezone: json['timezone'] ?? 'Asia/Dhaka',
    );
  }
}
