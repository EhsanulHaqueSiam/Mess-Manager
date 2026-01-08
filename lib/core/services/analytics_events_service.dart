import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mess_manager/core/services/firebase_service.dart';

/// Firebase Analytics Events Service
/// Provides typed methods for tracking specific user actions
class AnalyticsEvents {
  static FirebaseAnalytics get _analytics => FirebaseService.analytics;

  // ═══════════════════════════════════════════════════════════════════════════
  // MEAL EVENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Log when user adds a meal
  static Future<void> logMealAdded({
    required String mealType,
    required double count,
    bool isGuest = false,
  }) async {
    await _analytics.logEvent(
      name: 'meal_added',
      parameters: {'meal_type': mealType, 'count': count, 'is_guest': isGuest},
    );
  }

  /// Log bulk meal entry
  static Future<void> logBulkMealAdded({
    required int daysCount,
    required double totalMeals,
  }) async {
    await _analytics.logEvent(
      name: 'bulk_meal_added',
      parameters: {'days_count': daysCount, 'total_meals': totalMeals},
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BAZAR EVENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Log when user adds a bazar entry
  static Future<void> logBazarAdded({
    required double amount,
    required int itemCount,
    String? category,
  }) async {
    await _analytics.logEvent(
      name: 'bazar_added',
      parameters: {
        'amount': amount,
        'item_count': itemCount,
        'category': category ?? 'general',
      },
    );
  }

  /// Log NLP categorization usage
  static Future<void> logNlpCategorization({
    required String category,
    required double confidence,
    required bool accepted,
  }) async {
    await _analytics.logEvent(
      name: 'nlp_categorization',
      parameters: {
        'category': category,
        'confidence': confidence,
        'accepted': accepted,
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MONEY EVENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Log money transaction
  static Future<void> logTransactionAdded({
    required String type,
    required double amount,
    bool hasPhoto = false,
  }) async {
    await _analytics.logEvent(
      name: 'transaction_added',
      parameters: {'type': type, 'amount': amount, 'has_photo': hasPhoto},
    );
  }

  /// Log settlement action
  static Future<void> logSettlementPaid({required double amount}) async {
    await _analytics.logEvent(
      name: 'settlement_paid',
      parameters: {'amount': amount},
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FEATURE USAGE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Log screen view (for custom tracking)
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Log chatbot usage
  static Future<void> logChatbotMessage({required String messageType}) async {
    await _analytics.logEvent(
      name: 'chatbot_message',
      parameters: {'message_type': messageType},
    );
  }

  /// Log export action
  static Future<void> logExport({
    required String format,
    required String source,
  }) async {
    await _analytics.logEvent(
      name: 'data_exported',
      parameters: {'format': format, 'source': source},
    );
  }

  /// Log Ramadan feature usage
  static Future<void> logRamadanAction({required String action}) async {
    await _analytics.logEvent(
      name: 'ramadan_action',
      parameters: {'action': action},
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTH EVENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Log login method
  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  /// Log signup
  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  /// Log mess joined
  static Future<void> logMessJoined({required String method}) async {
    await _analytics.logEvent(
      name: 'mess_joined',
      parameters: {'method': method},
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // USER PROPERTIES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Set user role property
  static Future<void> setUserRole(String role) async {
    await _analytics.setUserProperty(name: 'user_role', value: role);
  }

  /// Set mess size property
  static Future<void> setMessSize(int memberCount) async {
    final size = memberCount <= 4
        ? 'small'
        : (memberCount <= 8 ? 'medium' : 'large');
    await _analytics.setUserProperty(name: 'mess_size', value: size);
  }
}
