import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mess_manager/core/database/isar_service.dart';

/// DESCO Prepaid Meter API Service
///
/// Smart Caching Strategy:
/// - DESCO only updates balance between 12am-2am BD time
/// - API is slow and sometimes unreliable
/// - Cache for entire day unless user force refreshes
/// - Show "estimated" balance based on consumption patterns
/// - "Confirm" button for critical low-balance verification
class DescoService {
  static const String _baseUrl = 'https://prepaid.desco.org.bd/api';

  // Default account/meter numbers (configurable in settings)
  static String accountNo = '33012161';
  static String meterNo = '661120196612';

  // Cache duration: Until next DESCO update window (2am BD time)
  // If current time is after 2am, cache until tomorrow 2am
  static Duration get _smartCacheDuration {
    final now = DateTime.now();
    final bdTime = now.toUtc().add(const Duration(hours: 6)); // BD is UTC+6

    // Next update window is 2am BD time
    var nextUpdate = DateTime(bdTime.year, bdTime.month, bdTime.day, 2);
    if (bdTime.hour >= 2) {
      // Already past 2am, cache until tomorrow 2am
      nextUpdate = nextUpdate.add(const Duration(days: 1));
    }

    return nextUpdate.difference(bdTime);
  }

  // Cache keys
  static const String _balanceCacheKey = 'desco_balance';
  static const String _balanceTimestampKey = 'desco_balance_ts';
  static const String _consumptionCacheKey = 'desco_consumption';
  static const String _rechargeCacheKey = 'desco_recharge';
  static const String _locationCacheKey = 'desco_location';
  static const String _lastKnownBalanceKey = 'desco_last_known_balance';
  static const String _avgDailyUsageKey = 'desco_avg_daily_usage';
  static const String _meterConfigKey = 'desco_meter_config';

  /// Initialize meter from saved config
  static Future<void> loadSavedMeter() async {
    final config = IsarService.getSetting<String>(_meterConfigKey);
    if (config != null) {
      try {
        final data = jsonDecode(config);
        accountNo = data['accountNo'] ?? accountNo;
        meterNo = data['meterNo'] ?? meterNo;
      } catch (_) {}
    }
  }

  /// Lookup meter info using accountNo OR meterNo
  /// accountNo = 8 digits, meterNo = 12 digits
  /// Returns DescoCustomerInfo if found, null if not
  static Future<DescoCustomerInfo?> lookupMeter({
    String? inputAccountNo,
    String? inputMeterNo,
  }) async {
    if (inputAccountNo == null && inputMeterNo == null) return null;

    // Validate input format
    if (inputAccountNo != null && inputAccountNo.length != 8) return null;
    if (inputMeterNo != null && inputMeterNo.length != 12) return null;

    try {
      final url =
          '$_baseUrl/tkdes/customer/getCustomerInfo'
          '?accountNo=${inputAccountNo ?? ''}&meterNo=${inputMeterNo ?? ''}';
      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('DESCO API timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return DescoCustomerInfo.fromJson(data);
        }
      }
    } catch (_) {}
    return null;
  }

  /// Setup meter after successful lookup
  /// Saves config and clears old cache
  static Future<bool> setupMeter(DescoCustomerInfo info) async {
    if (info.accountNo == null || info.meterNo == null) return false;

    // Update static fields
    accountNo = info.accountNo!;
    meterNo = info.meterNo!;

    // Save config
    IsarService.saveSetting(
      _meterConfigKey,
      jsonEncode({
        'accountNo': info.accountNo,
        'meterNo': info.meterNo,
        'customerName': info.customerName,
        'setupAt': DateTime.now().toIso8601String(),
      }),
    );

    // Clear old cache (new meter = new data)
    IsarService.removeSetting(_balanceCacheKey);
    IsarService.removeSetting(_balanceTimestampKey);
    IsarService.removeSetting(_lastKnownBalanceKey);
    IsarService.removeSetting(_locationCacheKey);

    return true;
  }

  /// Check if meter is configured
  static bool get isMeterConfigured {
    final config = IsarService.getSetting<String>(_meterConfigKey);
    return config != null;
  }

  /// Get current meter config
  static DescoMeterConfig? get currentConfig {
    final config = IsarService.getSetting<String>(_meterConfigKey);
    if (config == null) return null;
    try {
      return DescoMeterConfig.fromJson(jsonDecode(config));
    } catch (_) {
      return null;
    }
  }

  /// Get balance with smart caching
  /// Returns cached data if within DESCO update window
  /// [forceRefresh] - Bypass cache (for "Confirm Balance" button)
  static Future<DescoBalance?> getBalance({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = _getCachedBalance();
      if (cached != null) return cached;
    }

    try {
      final url =
          '$_baseUrl/tkdes/customer/getBalance'
          '?accountNo=$accountNo&meterNo=$meterNo';
      final response = await http
          .get(Uri.parse(url))
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('DESCO API timeout'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final balance = DescoBalance.fromJson(data);
        await _cacheBalance(balance);
        await _updateUsageStats(balance);
        return balance;
      }
    } catch (e) {
      // Return cached if API fails (API often down/slow)
      return _getCachedBalance() ?? _getEstimatedBalance();
    }
    return null;
  }

  /// Get ESTIMATED current balance (no API call)
  /// Based on last known balance - (days * avg daily usage)
  static DescoBalance? _getEstimatedBalance() {
    final lastKnown = IsarService.getSetting<String>(_lastKnownBalanceKey);
    final avgUsage = IsarService.getSetting<double>(_avgDailyUsageKey);
    final lastTs = IsarService.getSetting<String>(_balanceTimestampKey);

    if (lastKnown == null) return null;

    try {
      final lastBalance = double.parse(lastKnown);
      final lastDate = DateTime.tryParse(lastTs ?? '');
      final daysSince = lastDate != null
          ? DateTime.now().difference(lastDate).inDays
          : 0;

      final estimatedBalance = lastBalance - (daysSince * (avgUsage ?? 20.0));
      return DescoBalance(
        currentBalance: estimatedBalance > 0 ? estimatedBalance : 0,
        isEstimated: true,
        lastUpdated: lastDate,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get monthly consumption for a year (cached for 1 week)
  static Future<List<DescoConsumption>> getMonthlyConsumption({
    required int year,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${_consumptionCacheKey}_$year';
    final cacheTs = '${cacheKey}_ts';

    if (!forceRefresh) {
      final tsStr = IsarService.getSetting<String>(cacheTs);
      if (tsStr != null) {
        final ts = DateTime.tryParse(tsStr);
        // Cache consumption data for 1 week (doesn't change often)
        if (ts != null && DateTime.now().difference(ts).inDays < 7) {
          final cached = IsarService.getSetting<String>(cacheKey);
          if (cached != null) {
            try {
              final list = jsonDecode(cached) as List;
              return list.map((e) => DescoConsumption.fromJson(e)).toList();
            } catch (_) {}
          }
        }
      }
    }

    try {
      final url =
          '$_baseUrl/tkdes/customer/getCustomerMonthlyConsumption'
          '?accountNo=$accountNo&meterNo='
          '&monthFrom=$year-01&monthTo=$year-12';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['data'] as List? ?? [])
            .map((e) => DescoConsumption.fromJson(e))
            .toList();
        IsarService.saveSetting(cacheKey, jsonEncode(data['data']));
        IsarService.saveSetting(
          cacheTs,
          DateTime.now().toIso8601String(),
        );
        return list;
      }
    } catch (_) {}
    return [];
  }

  /// Get recharge history (cached for 1 day)
  static Future<List<DescoRecharge>> getRechargeHistory({
    required DateTime from,
    required DateTime to,
    bool forceRefresh = false,
  }) async {
    final dateKey = '${from.year}';
    final cacheKey = '${_rechargeCacheKey}_$dateKey';
    final cacheTs = '${cacheKey}_ts';

    if (!forceRefresh) {
      final tsStr = IsarService.getSetting<String>(cacheTs);
      if (tsStr != null) {
        final ts = DateTime.tryParse(tsStr);
        // Cache recharge data for 1 day
        if (ts != null && DateTime.now().difference(ts).inHours < 24) {
          final cached = IsarService.getSetting<String>(cacheKey);
          if (cached != null) {
            try {
              final list = jsonDecode(cached) as List;
              return list.map((e) => DescoRecharge.fromJson(e)).toList();
            } catch (_) {}
          }
        }
      }
    }

    try {
      final fromStr =
          '${from.year}-${from.month.toString().padLeft(2, '0')}-${from.day.toString().padLeft(2, '0')}';
      final toStr =
          '${to.year}-${to.month.toString().padLeft(2, '0')}-${to.day.toString().padLeft(2, '0')}';
      final url =
          '$_baseUrl/tkdes/customer/getRechargeHistory'
          '?accountNo=$accountNo&meterNo='
          '&dateFrom=$fromStr&dateTo=$toStr';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['data'] as List? ?? [])
            .map((e) => DescoRecharge.fromJson(e))
            .toList();
        IsarService.saveSetting(cacheKey, jsonEncode(data['data']));
        IsarService.saveSetting(
          cacheTs,
          DateTime.now().toIso8601String(),
        );
        return list;
      }
    } catch (_) {}
    return [];
  }

  /// Get customer location (cached indefinitely - doesn't change)
  static Future<DescoLocation?> getLocation({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = IsarService.getSetting<String>(_locationCacheKey);
      if (cached != null) {
        try {
          return DescoLocation.fromJson(jsonDecode(cached));
        } catch (_) {}
      }
    }

    try {
      final url = '$_baseUrl/common/getCustomerLocation?accountNo=$accountNo';
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final location = DescoLocation.fromJson(data);
        IsarService.saveSetting(_locationCacheKey, jsonEncode(data));
        return location;
      }
    } catch (_) {}
    return null;
  }

  // Cache helpers
  static DescoBalance? _getCachedBalance() {
    final tsStr = IsarService.getSetting<String>(_balanceTimestampKey);
    if (tsStr == null) return null;

    final timestamp = DateTime.tryParse(tsStr);
    if (timestamp == null) return null;

    // Smart cache: valid until next DESCO update window (2am BD)
    if (DateTime.now().difference(timestamp) > _smartCacheDuration) return null;

    final cached = IsarService.getSetting<String>(_balanceCacheKey);
    if (cached == null) return null;

    try {
      return DescoBalance.fromJson(jsonDecode(cached));
    } catch (_) {
      return null;
    }
  }

  static Future<void> _cacheBalance(DescoBalance balance) async {
    IsarService.saveSetting(
      _balanceCacheKey,
      jsonEncode(balance.toJson()),
    );
    IsarService.saveSetting(
      _balanceTimestampKey,
      DateTime.now().toIso8601String(),
    );
    IsarService.saveSetting(
      _lastKnownBalanceKey,
      balance.currentBalance.toString(),
    );
  }

  /// Update usage statistics for estimation
  static Future<void> _updateUsageStats(DescoBalance balance) async {
    final lastKnown = IsarService.getSetting<String>(_lastKnownBalanceKey);
    final lastTs = IsarService.getSetting<String>(_balanceTimestampKey);

    if (lastKnown != null && lastTs != null) {
      final lastBalance = double.tryParse(lastKnown);
      final lastDate = DateTime.tryParse(lastTs);

      if (lastBalance != null && lastDate != null) {
        final daysSince = DateTime.now().difference(lastDate).inDays;
        if (daysSince > 0) {
          final dailyUsage = (lastBalance - balance.currentBalance) / daysSince;
          if (dailyUsage > 0) {
            IsarService.saveSetting(_avgDailyUsageKey, dailyUsage);
          }
        }
      }
    }
  }

  /// Check if balance is low (below threshold)
  /// Returns "estimated" warning first, then "confirm" for API check
  static Future<LowBalanceStatus> checkLowBalance({
    double threshold = 200,
    bool confirm = false,
  }) async {
    if (confirm) {
      // User clicked "Confirm" - make actual API call
      final balance = await getBalance(forceRefresh: true);
      if (balance == null) return LowBalanceStatus.unknown;
      return balance.currentBalance < threshold
          ? LowBalanceStatus.confirmedLow
          : LowBalanceStatus.confirmedOk;
    }

    // Quick check with cached/estimated data
    final cached = _getCachedBalance();
    if (cached != null) {
      return cached.currentBalance < threshold
          ? LowBalanceStatus.estimatedLow
          : LowBalanceStatus.estimatedOk;
    }

    final estimated = _getEstimatedBalance();
    if (estimated != null) {
      return estimated.currentBalance < threshold
          ? LowBalanceStatus.estimatedLow
          : LowBalanceStatus.estimatedOk;
    }

    return LowBalanceStatus.unknown;
  }

  /// Get estimated days until balance runs out
  static int? getEstimatedDaysRemaining() {
    final cached = _getCachedBalance();
    final avgUsage = IsarService.getSetting<double>(_avgDailyUsageKey);

    if (cached == null || avgUsage == null || avgUsage <= 0) return null;

    return (cached.currentBalance / avgUsage).floor();
  }
}

/// Low balance status
enum LowBalanceStatus {
  estimatedOk, // Cached/estimated says OK
  estimatedLow, // Cached/estimated says low - show warning
  confirmedOk, // API confirmed OK
  confirmedLow, // API confirmed LOW - urgent!
  unknown, // No data available
}

/// DESCO Balance model
class DescoBalance {
  final double currentBalance;
  final double lastRechargeAmount;
  final DateTime? lastRechargeDate;
  final DateTime? lastUpdated;
  final String? meterNo;
  final String? accountNo;
  final String? customerName;
  final bool isEstimated; // True if calculated, not from API

  DescoBalance({
    required this.currentBalance,
    this.lastRechargeAmount = 0,
    this.lastRechargeDate,
    this.lastUpdated,
    this.meterNo,
    this.accountNo,
    this.customerName,
    this.isEstimated = false,
  });

  factory DescoBalance.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DescoBalance(
      currentBalance: (data['balance'] ?? data['currentBalance'] ?? 0)
          .toDouble(),
      lastRechargeAmount: (data['lastRechargeAmount'] ?? 0).toDouble(),
      lastRechargeDate: data['lastRechargeDate'] != null
          ? DateTime.tryParse(data['lastRechargeDate'].toString())
          : null,
      lastUpdated: DateTime.now(),
      meterNo: data['meterNo']?.toString(),
      accountNo: data['accountNo']?.toString(),
      customerName: data['customerName']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'currentBalance': currentBalance,
    'lastRechargeAmount': lastRechargeAmount,
    'lastRechargeDate': lastRechargeDate?.toIso8601String(),
    'lastUpdated': lastUpdated?.toIso8601String(),
    'meterNo': meterNo,
    'accountNo': accountNo,
    'customerName': customerName,
    'isEstimated': isEstimated,
  };
}

/// DESCO Monthly Consumption model
class DescoConsumption {
  final String month;
  final double units;
  final double amount;
  final double? perUnitRate;

  DescoConsumption({
    required this.month,
    required this.units,
    required this.amount,
    this.perUnitRate,
  });

  factory DescoConsumption.fromJson(Map<String, dynamic> json) {
    final units = (json['units'] ?? json['consumption'] ?? 0).toDouble();
    final amount = (json['amount'] ?? json['bill'] ?? 0).toDouble();
    return DescoConsumption(
      month: json['month']?.toString() ?? '',
      units: units,
      amount: amount,
      perUnitRate: units > 0 ? amount / units : null,
    );
  }
}

/// DESCO Recharge model
class DescoRecharge {
  final DateTime date;
  final double amount;
  final String? transactionId;
  final String? source;

  DescoRecharge({
    required this.date,
    required this.amount,
    this.transactionId,
    this.source,
  });

  factory DescoRecharge.fromJson(Map<String, dynamic> json) {
    return DescoRecharge(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      amount: (json['amount'] ?? 0).toDouble(),
      transactionId: json['transactionId']?.toString(),
      source: json['source']?.toString(),
    );
  }
}

/// DESCO Location model
class DescoLocation {
  final String? address;
  final String? area;
  final String? zone;
  final double? latitude;
  final double? longitude;

  DescoLocation({
    this.address,
    this.area,
    this.zone,
    this.latitude,
    this.longitude,
  });

  factory DescoLocation.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DescoLocation(
      address: data['address']?.toString(),
      area: data['area']?.toString(),
      zone: data['zone']?.toString(),
      latitude: (data['latitude'] ?? data['lat'])?.toDouble(),
      longitude: (data['longitude'] ?? data['lng'])?.toDouble(),
    );
  }
}

/// DESCO Customer Info (from getCustomerInfo API)
class DescoCustomerInfo {
  final String? accountNo;
  final String? meterNo;
  final String? customerName;
  final String? address;
  final String? area;
  final String? category;
  final String? status;

  DescoCustomerInfo({
    this.accountNo,
    this.meterNo,
    this.customerName,
    this.address,
    this.area,
    this.category,
    this.status,
  });

  factory DescoCustomerInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return DescoCustomerInfo(
      accountNo: data['accountNo']?.toString(),
      meterNo: data['meterNo']?.toString(),
      customerName:
          data['customerName']?.toString() ?? data['name']?.toString(),
      address: data['address']?.toString(),
      area: data['area']?.toString(),
      category: data['category']?.toString(),
      status: data['status']?.toString(),
    );
  }

  bool get isValid => accountNo != null && meterNo != null;
}

/// DESCO Meter Config (saved in app)
class DescoMeterConfig {
  final String accountNo;
  final String meterNo;
  final String? customerName;
  final DateTime? setupAt;

  DescoMeterConfig({
    required this.accountNo,
    required this.meterNo,
    this.customerName,
    this.setupAt,
  });

  factory DescoMeterConfig.fromJson(Map<String, dynamic> json) {
    return DescoMeterConfig(
      accountNo: json['accountNo'] ?? '',
      meterNo: json['meterNo'] ?? '',
      customerName: json['customerName'],
      setupAt: json['setupAt'] != null
          ? DateTime.tryParse(json['setupAt'].toString())
          : null,
    );
  }
}
