import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Voice Entry Service
///
/// Provides speech-to-text for natural language meal/bazar entry.
/// Supports commands like:
/// - "Add 2 lunch for today"
/// - "Add 3 meals tomorrow"
/// - "Add bazar 500 taka vegetables"
/// - "2 dinner plus 1 guest"

/// Parsed voice command result
class VoiceCommand {
  final VoiceCommandType type;
  final int count;
  final String? mealType; // breakfast, lunch, dinner
  final String? date; // today, tomorrow, yesterday
  final double? amount; // for bazar
  final String? description; // for bazar items
  final int guestCount;
  final String rawText;
  final double confidence;

  const VoiceCommand({
    required this.type,
    this.count = 0,
    this.mealType,
    this.date,
    this.amount,
    this.description,
    this.guestCount = 0,
    required this.rawText,
    this.confidence = 0.0,
  });

  bool get isValid => type != VoiceCommandType.unknown;

  @override
  String toString() {
    if (type == VoiceCommandType.meal) {
      final guest = guestCount > 0 ? ' + $guestCount guest' : '';
      return 'Add $count ${mealType ?? 'meal'}${count > 1 ? 's' : ''} for ${date ?? 'today'}$guest';
    } else if (type == VoiceCommandType.bazar) {
      return 'Add bazar ৳${amount?.toStringAsFixed(0) ?? '0'}: ${description ?? 'items'}';
    }
    return 'Unknown: $rawText';
  }
}

enum VoiceCommandType { meal, bazar, unknown }

/// Voice Entry Service State
class VoiceEntryState {
  final bool isInitialized;
  final bool isListening;
  final String currentText;
  final VoiceCommand? lastCommand;
  final String? error;
  final List<String> availableLocales;

  const VoiceEntryState({
    this.isInitialized = false,
    this.isListening = false,
    this.currentText = '',
    this.lastCommand,
    this.error,
    this.availableLocales = const [],
  });

  VoiceEntryState copyWith({
    bool? isInitialized,
    bool? isListening,
    String? currentText,
    VoiceCommand? lastCommand,
    String? error,
    List<String>? availableLocales,
  }) {
    return VoiceEntryState(
      isInitialized: isInitialized ?? this.isInitialized,
      isListening: isListening ?? this.isListening,
      currentText: currentText ?? this.currentText,
      lastCommand: lastCommand ?? this.lastCommand,
      error: error,
      availableLocales: availableLocales ?? this.availableLocales,
    );
  }
}

/// Voice Entry Notifier using Riverpod's Notifier pattern
class VoiceEntryNotifier extends Notifier<VoiceEntryState> {
  final SpeechToText _speech = SpeechToText();

  @override
  VoiceEntryState build() => const VoiceEntryState();

  /// Initialize speech recognition
  Future<bool> initialize() async {
    if (state.isInitialized) return true;

    try {
      final available = await _speech.initialize(
        onStatus: _onStatus,
        onError: _onError,
      );

      if (available) {
        final locales = await _speech.locales();
        state = state.copyWith(
          isInitialized: true,
          availableLocales: locales.map((l) => l.localeId).toList(),
        );
      } else {
        state = state.copyWith(
          error: 'Speech recognition not available on this device',
        );
      }

      return available;
    } catch (e) {
      state = state.copyWith(error: 'Failed to initialize: $e');
      return false;
    }
  }

  /// Start listening for voice input
  Future<void> startListening({String? localeId}) async {
    if (!state.isInitialized) {
      final success = await initialize();
      if (!success) return;
    }

    HapticService.bouncyTap();

    state = state.copyWith(isListening: true, currentText: '', error: null);

    await _speech.listen(onResult: _onResult, localeId: localeId ?? 'en_US');
  }

  /// Stop listening
  Future<void> stopListening() async {
    await _speech.stop();
    state = state.copyWith(isListening: false);

    // Parse the final result
    if (state.currentText.isNotEmpty) {
      final command = parseCommand(state.currentText);
      state = state.copyWith(lastCommand: command);

      if (command.isValid) {
        HapticService.bouncyConfirm();
      } else {
        HapticService.warning();
      }
    }
  }

  /// Cancel listening
  Future<void> cancelListening() async {
    await _speech.cancel();
    state = state.copyWith(isListening: false, currentText: '');
  }

  void _onStatus(String status) {
    if (status == 'done' || status == 'notListening') {
      state = state.copyWith(isListening: false);
    }
  }

  void _onError(SpeechRecognitionError error) {
    state = state.copyWith(
      isListening: false,
      error: 'Speech error: ${error.errorMsg}',
    );
    HapticService.error();
  }

  void _onResult(SpeechRecognitionResult result) {
    state = state.copyWith(currentText: result.recognizedWords);

    // Provide haptic feedback on word boundaries
    if (result.recognizedWords.contains(' ')) {
      HapticService.microTick();
    }

    // If final result, parse the command
    if (result.finalResult) {
      final command = parseCommand(result.recognizedWords);
      state = state.copyWith(lastCommand: command, isListening: false);
    }
  }

  /// Parse natural language command
  VoiceCommand parseCommand(String text) {
    final lower = text.toLowerCase().trim();
    final confidence = _speech.lastRecognizedWords == text ? 1.0 : 0.8;

    // Check for bazar/shopping commands
    if (_containsAny(lower, [
      'bazar',
      'bazaar',
      'shopping',
      'buy',
      'bought',
      'spent',
    ])) {
      return _parseBazarCommand(lower, text, confidence);
    }

    // Default to meal command
    return _parseMealCommand(lower, text, confidence);
  }

  VoiceCommand _parseMealCommand(
    String lower,
    String rawText,
    double confidence,
  ) {
    // Extract count (number)
    int count = _extractNumber(lower) ?? 2; // Default to 2 meals

    // Extract meal type
    String? mealType;
    if (_containsAny(lower, ['breakfast', 'morning'])) {
      mealType = 'breakfast';
    } else if (_containsAny(lower, ['lunch', 'noon', 'afternoon'])) {
      mealType = 'lunch';
    } else if (_containsAny(lower, ['dinner', 'night', 'evening'])) {
      mealType = 'dinner';
    }

    // Extract date
    String date = 'today';
    if (_containsAny(lower, ['tomorrow', 'tmrw'])) {
      date = 'tomorrow';
    } else if (_containsAny(lower, ['yesterday'])) {
      date = 'yesterday';
    }

    // Extract guest count
    int guestCount = 0;
    final guestMatch = RegExp(r'(\d+)\s*guest').firstMatch(lower);
    if (guestMatch != null) {
      guestCount = int.tryParse(guestMatch.group(1) ?? '0') ?? 0;
    } else if (_containsAny(lower, ['guest', 'guests'])) {
      guestCount = 1;
    }

    return VoiceCommand(
      type: VoiceCommandType.meal,
      count: count,
      mealType: mealType,
      date: date,
      guestCount: guestCount,
      rawText: rawText,
      confidence: confidence,
    );
  }

  VoiceCommand _parseBazarCommand(
    String lower,
    String rawText,
    double confidence,
  ) {
    // Extract amount
    double? amount;

    // Try patterns like "500 taka", "৳500", "500 tk"
    final amountPatterns = [
      RegExp(r'(\d+(?:\.\d+)?)\s*(?:taka|tk|৳)'),
      RegExp(r'৳\s*(\d+(?:\.\d+)?)'),
      RegExp(r'(\d{2,})\s'), // Any number >= 2 digits likely to be amount
    ];

    for (final pattern in amountPatterns) {
      final match = pattern.firstMatch(lower);
      if (match != null) {
        amount = double.tryParse(match.group(1) ?? '');
        if (amount != null) break;
      }
    }

    // Extract description (everything after the amount or category words)
    String? description;
    final descWords = lower
        .replaceAll(RegExp(r'\d+'), '')
        .replaceAll(
          RegExp(r'(bazar|bazaar|shopping|buy|bought|spent|taka|tk|৳|add)'),
          '',
        )
        .trim();
    if (descWords.isNotEmpty) {
      description = descWords.split(' ').where((w) => w.length > 2).join(' ');
    }

    return VoiceCommand(
      type: VoiceCommandType.bazar,
      amount: amount,
      description: description?.isNotEmpty == true ? description : 'items',
      rawText: rawText,
      confidence: confidence,
    );
  }

  int? _extractNumber(String text) {
    // Word to number mapping
    const wordNumbers = {
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9,
      'ten': 10,
      'a': 1,
      'an': 1,
    };

    // Check word numbers
    for (final entry in wordNumbers.entries) {
      if (text.contains(entry.key)) {
        return entry.value;
      }
    }

    // Check digit numbers
    final numMatch = RegExp(r'\b(\d+)\b').firstMatch(text);
    if (numMatch != null) {
      return int.tryParse(numMatch.group(1) ?? '');
    }

    return null;
  }

  bool _containsAny(String text, List<String> words) {
    return words.any((word) => text.contains(word));
  }
}

/// Voice Entry Provider
final voiceEntryProvider =
    NotifierProvider<VoiceEntryNotifier, VoiceEntryState>(
      VoiceEntryNotifier.new,
    );

/// Convenience provider for checking if speech is available
final speechAvailableProvider = Provider<bool>((ref) {
  return ref.watch(voiceEntryProvider).isInitialized;
});
