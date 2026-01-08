import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mess_manager/core/api/aladhan_api.dart';

/// Prayer Times Service - Uses Aladhan.com Free API via Retrofit
/// Provides accurate Iftar/Sehri times for Bangladesh districts
class PrayerTimesService {
  static AladhanApi? _api;
  static const int _method = 1; // University of Islamic Sciences, Karachi

  /// Initialize the API client
  static AladhanApi get api {
    _api ??= AladhanApi(
      Dio()
        ..options = BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
    );
    return _api!;
  }

  /// Bangladesh District Coordinates (Major districts)
  static const Map<String, (double lat, double lng)> _bdDistricts = {
    // Division: Dhaka
    'Dhaka': (23.8103, 90.4125),
    'Gazipur': (24.0023, 90.4264),
    'Narayanganj': (23.6238, 90.5000),
    'Tangail': (24.2513, 89.9164),
    'Manikganj': (23.8617, 90.0047),
    'Munshiganj': (23.5422, 90.5305),
    'Narsingdi': (23.9322, 90.7151),
    'Faridpur': (23.6072, 89.8321),
    'Madaripur': (23.1642, 90.1896),
    'Gopalganj': (23.0050, 89.8266),
    'Rajbari': (23.7574, 89.6445),
    'Shariatpur': (23.2423, 90.4348),
    'Kishoreganj': (24.4449, 90.7766),

    // Division: Chattogram
    'Chittagong': (22.3569, 91.7832),
    'Comilla': (23.4607, 91.1809),
    'Feni': (23.0159, 91.3976),
    'Brahmanbaria': (23.9571, 91.1112),
    'Noakhali': (22.8696, 91.0995),
    'Chandpur': (23.2513, 90.8518),
    'Lakshmipur': (22.9447, 90.8282),
    "Cox's Bazar": (21.4272, 92.0058),
    'Rangamati': (22.6372, 92.1988),
    'Khagrachhari': (23.1193, 91.9847),
    'Bandarban': (22.1953, 92.2184),

    // Division: Khulna
    'Khulna': (22.8456, 89.5403),
    'Jessore': (23.1634, 89.2182),
    'Satkhira': (22.3155, 89.1115),
    'Bagerhat': (22.6512, 89.7851),
    'Kushtia': (23.9013, 89.1205),
    'Meherpur': (23.7622, 88.6318),
    'Chuadanga': (23.6401, 88.8419),
    'Jhenaidah': (23.5448, 89.1726),
    'Magura': (23.4872, 89.4197),
    'Narail': (23.1725, 89.4951),

    // Division: Rajshahi
    'Rajshahi': (24.3636, 88.6241),
    'Bogra': (24.8466, 89.3773),
    'Pabna': (24.0064, 89.2372),
    'Sirajganj': (24.4534, 89.7001),
    'Natore': (24.4206, 89.0000),
    'Nawabganj': (24.5965, 88.2775),
    'Naogaon': (24.7936, 88.9318),
    'Joypurhat': (25.0947, 89.0227),

    // Division: Rangpur
    'Rangpur': (25.7439, 89.2752),
    'Dinajpur': (25.6217, 88.6354),
    'Kurigram': (25.8072, 89.6295),
    'Lalmonirhat': (25.9923, 89.2847),
    'Nilphamari': (25.9316, 88.8560),
    'Gaibandha': (25.3288, 89.5286),
    'Thakurgaon': (26.0336, 88.4616),
    'Panchagarh': (26.3411, 88.5542),

    // Division: Sylhet
    'Sylhet': (24.8949, 91.8687),
    'Moulvibazar': (24.4829, 91.7774),
    'Habiganj': (24.3840, 91.4155),
    'Sunamganj': (25.0658, 91.3950),

    // Division: Barishal
    'Barisal': (22.7010, 90.3535),
    'Bhola': (22.6859, 90.6482),
    'Patuakhali': (22.3596, 90.3299),
    'Pirojpur': (22.5790, 89.9759),
    'Jhalokati': (22.6406, 90.1987),
    'Barguna': (22.1530, 90.1266),

    // Division: Mymensingh
    'Mymensingh': (24.7471, 90.4203),
    'Jamalpur': (24.9375, 89.9372),
    'Sherpur': (25.0204, 90.0152),
    'Netrokona': (24.8703, 90.7279),
  };

  /// Get prayer times for a specific district and date
  static Future<PrayerTimes?> getTimesForDistrict({
    required String district,
    DateTime? date,
  }) async {
    final coords = _bdDistricts[district];
    if (coords == null) {
      // Fallback to Dhaka if district not found
      return getTimesByCoordinates(
        latitude: 23.8103,
        longitude: 90.4125,
        date: date,
      );
    }

    return getTimesByCoordinates(
      latitude: coords.$1,
      longitude: coords.$2,
      date: date,
    );
  }

  /// Get prayer times by coordinates using Retrofit
  static Future<PrayerTimes?> getTimesByCoordinates({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) async {
    try {
      final targetDate = date ?? DateTime.now();
      final dateStr =
          '${targetDate.day.toString().padLeft(2, '0')}-'
          '${targetDate.month.toString().padLeft(2, '0')}-'
          '${targetDate.year}';

      final response = await api.getTimingsByCoordinates(
        dateStr,
        latitude,
        longitude,
        method: _method,
      );

      if (response.code == 200 && response.data != null) {
        final timings = response.data!.timings;
        return PrayerTimes(
          fajr: timings.fajr,
          sunrise: timings.sunrise,
          dhuhr: timings.dhuhr,
          asr: timings.asr,
          sunset: timings.sunset,
          maghrib: timings.maghrib,
          isha: timings.isha,
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Prayer times API error: $e');
      return null;
    }
  }

  /// Get list of available districts
  static List<String> getAvailableDistricts() {
    return _bdDistricts.keys.toList()..sort();
  }
}

/// Prayer times model (simplified for UI)
class PrayerTimes {
  final String fajr; // Sehri ends
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset; // Maghrib / Iftar time
  final String maghrib; // Iftar time
  final String isha;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
  });

  /// Get Sehri end time (Fajr)
  String get sehriEnd => fajr;

  /// Get Iftar time (Maghrib)
  String get iftarTime => maghrib;

  /// Parse time string to DateTime
  DateTime parseTime(String time, DateTime baseDate) {
    final parts = time.split(':');
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Time remaining until Sehri/Iftar
  Duration? timeUntilSehri(DateTime now) {
    final sehri = parseTime(fajr, now);
    if (now.isBefore(sehri)) {
      return sehri.difference(now);
    }
    return null;
  }

  Duration? timeUntilIftar(DateTime now) {
    final iftar = parseTime(maghrib, now);
    if (now.isBefore(iftar)) {
      return iftar.difference(now);
    }
    return null;
  }
}
