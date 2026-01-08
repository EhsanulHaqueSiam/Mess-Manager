/// Location Service - Bazar Shopping Location Tracking
///
/// Tracks where bazar shopping was done for accountability and expense tracking.
/// Uses existing geolocator dependency to get current location.
library;

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Location data for a bazar entry
class BazarLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? placeName;
  final DateTime timestamp;

  const BazarLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'placeName': placeName,
    'timestamp': timestamp.toIso8601String(),
  };

  factory BazarLocation.fromJson(Map<String, dynamic> json) => BazarLocation(
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    address: json['address'] as String?,
    placeName: json['placeName'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  /// Get display string for UI
  String get displayName => placeName ?? address ?? 'Unknown Location';

  /// Get short display (e.g., "Bazar, Dhaka")
  String get shortDisplay {
    if (placeName != null) return placeName!;
    if (address != null) {
      final parts = address!.split(',');
      if (parts.length >= 2) return '${parts[0].trim()}, ${parts[1].trim()}';
      return parts[0].trim();
    }
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }
}

/// Location Service for tracking bazar shopping locations
class LocationService {
  static bool _isEnabled = true;

  /// Check if location services are available
  static Future<bool> isAvailable() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('⚠️ Location service check failed: $e');
      return false;
    }
  }

  /// Request location permission
  static Future<bool> requestPermission() async {
    try {
      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ Location permission permanently denied');
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      debugPrint('⚠️ Location permission request failed: $e');
      return false;
    }
  }

  /// Get current location with reverse geocoding
  static Future<BazarLocation?> getCurrentLocation() async {
    if (!_isEnabled) return null;

    try {
      // Check permission
      final hasPermission = await requestPermission();
      if (!hasPermission) return null;

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );

      // Try reverse geocoding
      String? address;
      String? placeName;

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          placeName = place.name ?? place.locality;

          // Build full address
          final parts = <String>[
            if (place.street != null && place.street!.isNotEmpty) place.street!,
            if (place.locality != null && place.locality!.isNotEmpty)
              place.locality!,
            if (place.subAdministrativeArea != null &&
                place.subAdministrativeArea!.isNotEmpty)
              place.subAdministrativeArea!,
            if (place.country != null && place.country!.isNotEmpty)
              place.country!,
          ];
          address = parts.join(', ');
        }
      } catch (e) {
        debugPrint('⚠️ Reverse geocoding failed: $e');
        // Continue without address
      }

      return BazarLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        placeName: placeName,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      debugPrint('⚠️ Failed to get location: $e');
      return null;
    }
  }

  /// Calculate distance between two locations (in meters)
  static double distanceBetween(BazarLocation loc1, BazarLocation loc2) {
    return Geolocator.distanceBetween(
      loc1.latitude,
      loc1.longitude,
      loc2.latitude,
      loc2.longitude,
    );
  }

  /// Enable location tracking
  static void enable() {
    _isEnabled = true;
    debugPrint('✅ Location tracking enabled');
  }

  /// Disable location tracking
  static void disable() {
    _isEnabled = false;
    debugPrint('❌ Location tracking disabled');
  }

  /// Check if location tracking is enabled
  static bool get isEnabled => _isEnabled;
}

/// Common shopping locations in Bangladesh
class CommonLocations {
  static const List<String> markets = [
    'কাওরান বাজার',
    'নিউ মার্কেট',
    'গুলশান মার্কেট',
    'মহাখালী বাজার',
    'বনানী মার্কেট',
    'মিরপুর বাজার',
    'উত্তরা বাজার',
    'ধানমন্ডি মার্কেট',
    'মোহাম্মদপুর বাজার',
  ];

  /// Check if location is near a known market
  static String? getNearbyMarket(BazarLocation location) {
    // This would require coordinates for each market
    // For now, use place name matching
    if (location.placeName != null) {
      for (final market in markets) {
        if (location.placeName!.contains('বাজার') ||
            location.placeName!.contains('Market') ||
            location.placeName!.toLowerCase().contains('bazar')) {
          return location.placeName;
        }
      }
    }
    return null;
  }
}
