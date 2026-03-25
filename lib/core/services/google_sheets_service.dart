import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Authenticated HTTP client using Google Sign-In access token.
class _AuthClient extends http.BaseClient {
  final String _accessToken;
  final http.Client _inner = http.Client();

  _AuthClient(this._accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}

/// Service for syncing mess data to Google Sheets.
///
/// Uses the authenticated user's Google account to write daily
/// meal, bazar, and balance data to a configured spreadsheet.
class GoogleSheetsService {
  static const _prefKeySheetId = 'google_sheets_id';
  static const _prefKeyEnabled = 'google_sheets_enabled';
  static const _prefKeyLastSync = 'google_sheets_last_sync';

  static final GoogleSheetsService _instance = GoogleSheetsService._();
  factory GoogleSheetsService() => _instance;
  GoogleSheetsService._();

  sheets.SheetsApi? _sheetsApi;
  String? _spreadsheetId;
  bool _enabled = false;

  bool get isEnabled => _enabled;
  String? get spreadsheetId => _spreadsheetId;

  /// Initialize from saved preferences.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _spreadsheetId = prefs.getString(_prefKeySheetId);
    _enabled = prefs.getBool(_prefKeyEnabled) ?? false;
  }

  /// Extract spreadsheet ID from a full Google Sheets URL or raw ID.
  static String? parseSpreadsheetId(String input) {
    input = input.trim();
    if (input.isEmpty) return null;

    // Full URL: https://docs.google.com/spreadsheets/d/SPREADSHEET_ID/edit...
    final urlMatch = RegExp(
      r'docs\.google\.com/spreadsheets/d/([a-zA-Z0-9_-]+)',
    ).firstMatch(input);
    if (urlMatch != null) return urlMatch.group(1);

    // Raw ID (alphanumeric + dashes/underscores, typically 40+ chars)
    if (RegExp(r'^[a-zA-Z0-9_-]{20,}$').hasMatch(input)) return input;

    return null;
  }

  /// Configure the spreadsheet to sync to.
  Future<void> configure({required String sheetUrl, required bool enabled}) async {
    final id = parseSpreadsheetId(sheetUrl);
    final prefs = await SharedPreferences.getInstance();

    _spreadsheetId = id;
    _enabled = enabled;
    _sheetsApi = null; // Reset API on config change

    if (id != null) {
      await prefs.setString(_prefKeySheetId, id);
    } else {
      await prefs.remove(_prefKeySheetId);
    }
    await prefs.setBool(_prefKeyEnabled, enabled);
  }

  /// Get the last sync timestamp.
  Future<DateTime?> getLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt(_prefKeyLastSync);
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }

  Future<void> _setLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _prefKeyLastSync,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Authenticate and create Sheets API client using Google Sign-In v7.
  ///
  /// Flow: authenticate → authorizeScopes → get accessToken → create API client.
  Future<sheets.SheetsApi?> _getApi() async {
    if (_sheetsApi != null) return _sheetsApi;

    try {
      // Ensure Google Sign-In is initialized (idempotent)
      await GoogleSignIn.instance.initialize();

      // Authenticate user (or reuse existing session)
      final account = await GoogleSignIn.instance.authenticate();

      // Request Sheets write scope — prompts consent UI if needed
      final authorization = await account.authorizationClient.authorizeScopes(
        [sheets.SheetsApi.spreadsheetsScope],
      );

      final client = _AuthClient(authorization.accessToken);
      _sheetsApi = sheets.SheetsApi(client);
      return _sheetsApi;
    } catch (e) {
      debugPrint('GoogleSheetsService: Auth error: $e');
      return null;
    }
  }

  /// Ensure the spreadsheet has the required tabs.
  Future<bool> ensureSheetTabs(sheets.SheetsApi api, String sheetId) async {
    try {
      final spreadsheet = await api.spreadsheets.get(sheetId);
      final existingTabs =
          spreadsheet.sheets?.map((s) => s.properties?.title).toSet() ?? {};

      const requiredTabs = ['Daily Summary', 'Meals', 'Bazar', 'Balance'];
      final missingTabs =
          requiredTabs.where((t) => !existingTabs.contains(t)).toList();

      if (missingTabs.isNotEmpty) {
        final requests = missingTabs
            .map((tab) => sheets.Request(
                  addSheet: sheets.AddSheetRequest(
                    properties: sheets.SheetProperties(title: tab),
                  ),
                ))
            .toList();

        await api.spreadsheets.batchUpdate(
          sheets.BatchUpdateSpreadsheetRequest(requests: requests),
          sheetId,
        );
      }

      // Write headers for each tab
      await _writeHeaders(api, sheetId, existingTabs);
      return true;
    } catch (e) {
      debugPrint('GoogleSheetsService: Tab setup error: $e');
      return false;
    }
  }

  Future<void> _writeHeaders(
    sheets.SheetsApi api,
    String sheetId,
    Set<String?> existingTabs,
  ) async {
    final headerMap = {
      'Daily Summary': [
        'Date',
        'Total Meals',
        'Total Bazar (৳)',
        'Meal Rate (৳)',
        'Members',
      ],
      'Meals': [
        'Date',
        'Member',
        'Meals Count',
        'Type',
      ],
      'Bazar': [
        'Date',
        'Member',
        'Amount (৳)',
        'Description',
        'Items',
      ],
      'Balance': [
        'Date',
        'Member',
        'Meals',
        'Bazar Spent (৳)',
        'Meal Cost (৳)',
        'Balance (৳)',
      ],
    };

    for (final entry in headerMap.entries) {
      // Only write headers for newly created tabs
      if (!existingTabs.contains(entry.key)) {
        await api.spreadsheets.values.update(
          sheets.ValueRange(values: [entry.value]),
          sheetId,
          '${entry.key}!A1',
          valueInputOption: 'RAW',
        );
      }
    }
  }

  /// Sync daily data to Google Sheet.
  ///
  /// Call this after meals/bazar changes or on a daily schedule.
  Future<SyncResult> syncDailyData({
    required String date,
    required double totalMeals,
    required double totalBazar,
    required double mealRate,
    required int memberCount,
    required List<Map<String, dynamic>> mealRows,
    required List<Map<String, dynamic>> bazarRows,
    required List<Map<String, dynamic>> balanceRows,
  }) async {
    if (!_enabled || _spreadsheetId == null) {
      return SyncResult.disabled;
    }

    try {
      final api = await _getApi();
      if (api == null) return SyncResult.authFailed;

      await ensureSheetTabs(api, _spreadsheetId!);

      // 1. Append daily summary
      await api.spreadsheets.values.append(
        sheets.ValueRange(values: [
          [date, totalMeals, totalBazar, mealRate, memberCount],
        ]),
        _spreadsheetId!,
        'Daily Summary!A:E',
        valueInputOption: 'USER_ENTERED',
      );

      // 2. Append meal rows
      if (mealRows.isNotEmpty) {
        final rows = mealRows
            .map((m) => [
                  m['date'] ?? date,
                  m['member'] ?? '',
                  m['count'] ?? 0,
                  m['type'] ?? 'regular',
                ])
            .toList();
        await api.spreadsheets.values.append(
          sheets.ValueRange(values: rows),
          _spreadsheetId!,
          'Meals!A:D',
          valueInputOption: 'USER_ENTERED',
        );
      }

      // 3. Append bazar rows
      if (bazarRows.isNotEmpty) {
        final rows = bazarRows
            .map((b) => [
                  b['date'] ?? date,
                  b['member'] ?? '',
                  b['amount'] ?? 0,
                  b['description'] ?? '',
                  b['items'] ?? '',
                ])
            .toList();
        await api.spreadsheets.values.append(
          sheets.ValueRange(values: rows),
          _spreadsheetId!,
          'Bazar!A:E',
          valueInputOption: 'USER_ENTERED',
        );
      }

      // 4. Append balance rows
      if (balanceRows.isNotEmpty) {
        final rows = balanceRows
            .map((b) => [
                  b['date'] ?? date,
                  b['member'] ?? '',
                  b['meals'] ?? 0,
                  b['bazarSpent'] ?? 0,
                  b['mealCost'] ?? 0,
                  b['balance'] ?? 0,
                ])
            .toList();
        await api.spreadsheets.values.append(
          sheets.ValueRange(values: rows),
          _spreadsheetId!,
          'Balance!A:F',
          valueInputOption: 'USER_ENTERED',
        );
      }

      await _setLastSync();
      return SyncResult.success;
    } catch (e) {
      debugPrint('GoogleSheetsService: Sync error: $e');
      return SyncResult.error;
    }
  }

  /// Read recent data from all sheet tabs for RAG context.
  ///
  /// Returns a formatted string summary of the last ~7 days of data
  /// suitable for injecting into a chatbot system prompt.
  Future<String?> readSheetDataForRAG() async {
    if (!_enabled || _spreadsheetId == null) return null;

    try {
      final api = await _getApi();
      if (api == null) return null;

      final buffer = StringBuffer();

      // Read Daily Summary (last 7 rows)
      final daily = await _readTab(api, 'Daily Summary!A:E', 7);
      if (daily.isNotEmpty) {
        buffer.writeln('DAILY SUMMARY (recent):');
        for (final row in daily) {
          buffer.writeln('  ${row.join(' | ')}');
        }
        buffer.writeln();
      }

      // Read Meals (last 15 rows)
      final meals = await _readTab(api, 'Meals!A:D', 15);
      if (meals.isNotEmpty) {
        buffer.writeln('RECENT MEALS:');
        for (final row in meals) {
          buffer.writeln('  ${row.join(' | ')}');
        }
        buffer.writeln();
      }

      // Read Bazar (last 10 rows)
      final bazar = await _readTab(api, 'Bazar!A:E', 10);
      if (bazar.isNotEmpty) {
        buffer.writeln('RECENT BAZAR:');
        for (final row in bazar) {
          buffer.writeln('  ${row.join(' | ')}');
        }
        buffer.writeln();
      }

      // Read Balance (last rows = latest snapshot)
      final balance = await _readTab(api, 'Balance!A:F', 10);
      if (balance.isNotEmpty) {
        buffer.writeln('BALANCE SNAPSHOT:');
        for (final row in balance) {
          buffer.writeln('  ${row.join(' | ')}');
        }
      }

      final result = buffer.toString().trim();
      return result.isEmpty ? null : result;
    } catch (e) {
      debugPrint('GoogleSheetsService: RAG read error: $e');
      return null;
    }
  }

  /// Read the last N rows from a sheet tab.
  Future<List<List<Object?>>> _readTab(
    sheets.SheetsApi api,
    String range,
    int lastN,
  ) async {
    try {
      final response = await api.spreadsheets.values.get(
        _spreadsheetId!,
        range,
      );
      final values = response.values;
      if (values == null || values.isEmpty) return [];

      // Return header + last N data rows
      if (values.length <= 1) return values;
      final header = values.first;
      final dataRows = values.skip(1).toList();
      final recentRows = dataRows.length > lastN
          ? dataRows.sublist(dataRows.length - lastN)
          : dataRows;
      return [header, ...recentRows];
    } catch (_) {
      return [];
    }
  }

  /// Test connection by reading spreadsheet metadata.
  Future<String?> testConnection() async {
    if (_spreadsheetId == null) return 'No spreadsheet configured';

    try {
      final api = await _getApi();
      if (api == null) return 'Authentication failed';

      await api.spreadsheets.get(_spreadsheetId!);
      return null; // Success — return null means no error
    } catch (e) {
      return e.toString();
    }
  }
}

enum SyncResult { success, disabled, authFailed, error }
