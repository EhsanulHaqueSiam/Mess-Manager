import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Receipt OCR Service
///
/// Uses Google ML Kit to extract text from receipt images and parse:
/// - Item names
/// - Prices
/// - Total amount
///
/// Optimized for Bangladesh receipts (৳ symbol, BDT format)

/// Extracted receipt item
class ReceiptItem {
  final String name;
  final double price;
  final String rawText;
  final double confidence;

  const ReceiptItem({
    required this.name,
    required this.price,
    required this.rawText,
    this.confidence = 0.0,
  });

  @override
  String toString() => '$name: ৳${price.toStringAsFixed(0)}';
}

/// Receipt scan result
class ReceiptScanResult {
  final List<ReceiptItem> items;
  final double total;
  final double? detectedTotal;
  final String rawText;
  final DateTime scanTime;
  final bool success;
  final String? error;

  const ReceiptScanResult({
    this.items = const [],
    this.total = 0,
    this.detectedTotal,
    this.rawText = '',
    required this.scanTime,
    this.success = false,
    this.error,
  });

  /// Check if detected total matches sum of items
  bool get totalMatches {
    if (detectedTotal == null) return true;
    return (total - detectedTotal!).abs() < 5; // Allow ৳5 tolerance
  }
}

/// Receipt OCR State
class ReceiptOcrState {
  final bool isProcessing;
  final ReceiptScanResult? lastResult;
  final String? error;
  final double progress;

  const ReceiptOcrState({
    this.isProcessing = false,
    this.lastResult,
    this.error,
    this.progress = 0,
  });

  ReceiptOcrState copyWith({
    bool? isProcessing,
    ReceiptScanResult? lastResult,
    String? error,
    double? progress,
  }) {
    return ReceiptOcrState(
      isProcessing: isProcessing ?? this.isProcessing,
      lastResult: lastResult ?? this.lastResult,
      error: error,
      progress: progress ?? this.progress,
    );
  }
}

/// Receipt OCR Notifier
class ReceiptOcrNotifier extends Notifier<ReceiptOcrState> {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
  final ImagePicker _picker = ImagePicker();

  @override
  ReceiptOcrState build() => const ReceiptOcrState();

  /// Dispose the text recognizer
  Future<void> dispose() async {
    await _textRecognizer.close();
  }

  /// Scan receipt from camera
  Future<ReceiptScanResult?> scanFromCamera() async {
    try {
      HapticService.bouncyTap();

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _processImage(File(image.path));
    } catch (e) {
      state = state.copyWith(error: 'Camera error: $e');
      HapticService.error();
      return null;
    }
  }

  /// Scan receipt from gallery
  Future<ReceiptScanResult?> scanFromGallery() async {
    try {
      HapticService.bouncyTap();

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) return null;

      return await _processImage(File(image.path));
    } catch (e) {
      state = state.copyWith(error: 'Gallery error: $e');
      HapticService.error();
      return null;
    }
  }

  /// Scan receipt from file path
  Future<ReceiptScanResult?> scanFromFile(String path) async {
    return await _processImage(File(path));
  }

  /// Process image and extract text
  Future<ReceiptScanResult> _processImage(File imageFile) async {
    state = state.copyWith(isProcessing: true, progress: 0.1, error: null);

    try {
      // Create input image
      final inputImage = InputImage.fromFile(imageFile);

      state = state.copyWith(progress: 0.3);

      // Recognize text
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      state = state.copyWith(progress: 0.6);

      // Parse the recognized text
      final result = _parseReceiptText(recognizedText.text, recognizedText);

      state = state.copyWith(
        isProcessing: false,
        lastResult: result,
        progress: 1.0,
      );

      if (result.success) {
        HapticService.bouncyConfirm();
      } else {
        HapticService.warning();
      }

      return result;
    } catch (e) {
      final errorResult = ReceiptScanResult(
        scanTime: DateTime.now(),
        error: 'Processing failed: $e',
      );

      state = state.copyWith(
        isProcessing: false,
        lastResult: errorResult,
        error: 'Processing failed: $e',
      );

      HapticService.error();
      return errorResult;
    }
  }

  /// Parse recognized text into receipt items
  ReceiptScanResult _parseReceiptText(
    String rawText,
    RecognizedText recognized,
  ) {
    final List<ReceiptItem> items = [];
    double? detectedTotal;

    // Split into lines
    final lines = rawText
        .split('\n')
        .where((l) => l.trim().isNotEmpty)
        .toList();

    for (final line in lines) {
      // Try to extract price from line
      final priceData = _extractPrice(line);

      if (priceData != null) {
        final (price, priceStartIndex) = priceData;

        // Check if this is a total line
        if (_isTotalLine(line)) {
          detectedTotal = price;
          continue;
        }

        // Extract item name (text before price)
        String itemName = line.substring(0, priceStartIndex).trim();

        // Clean up item name
        itemName = _cleanItemName(itemName);

        if (itemName.isNotEmpty && price > 0) {
          items.add(
            ReceiptItem(
              name: itemName,
              price: price,
              rawText: line,
              confidence: 0.8,
            ),
          );
        }
      }
    }

    // Calculate total from items
    final calculatedTotal = items.fold<double>(
      0,
      (sum, item) => sum + item.price,
    );

    return ReceiptScanResult(
      items: items,
      total: calculatedTotal,
      detectedTotal: detectedTotal,
      rawText: rawText,
      scanTime: DateTime.now(),
      success: items.isNotEmpty,
    );
  }

  /// Extract price from a line of text
  /// Returns (price, startIndexOfPrice) or null if no price found
  (double, int)? _extractPrice(String line) {
    // Pattern matches: ৳500, 500৳, 500 tk, 500.00, etc.
    final patterns = [
      // ৳ symbol patterns
      RegExp(r'৳\s*(\d+(?:[.,]\d{1,2})?)'),
      RegExp(r'(\d+(?:[.,]\d{1,2})?)\s*৳'),
      // BDT/TK patterns
      RegExp(r'(\d+(?:[.,]\d{1,2})?)\s*(?:tk|taka|bdt)', caseSensitive: false),
      RegExp(r'(?:tk|taka|bdt)\s*(\d+(?:[.,]\d{1,2})?)', caseSensitive: false),
      // Plain number at end of line (likely price)
      RegExp(r'\s(\d{2,}(?:[.,]\d{1,2})?)\s*$'),
      // Number with decimal
      RegExp(r'(\d+[.,]\d{2})\s*$'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(line);
      if (match != null) {
        final priceStr = match.group(1)?.replaceAll(',', '.') ?? '';
        final price = double.tryParse(priceStr);
        if (price != null && price > 0 && price < 100000) {
          return (price, match.start);
        }
      }
    }

    return null;
  }

  /// Check if line contains total keywords
  bool _isTotalLine(String line) {
    final lower = line.toLowerCase();
    final totalKeywords = [
      'total', 'grand total', 'sub total', 'subtotal',
      'net total', 'amount', 'payable', 'due',
      'মোট', 'সর্বমোট', // Bengali
    ];

    return totalKeywords.any((keyword) => lower.contains(keyword));
  }

  /// Clean up extracted item name
  String _cleanItemName(String name) {
    // Remove common prefixes/suffixes
    name = name.replaceAll(
      RegExp(r'^[\d\s\.\-\*]+'),
      '',
    ); // Leading numbers, dots, etc.
    name = name.replaceAll(
      RegExp(r'[xX]\s*\d+\s*$'),
      '',
    ); // Quantity suffix like "x2"
    name = name.replaceAll(RegExp(r'\s{2,}'), ' '); // Multiple spaces
    name = name.trim();

    // Capitalize first letter
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1);
    }

    return name;
  }

  /// Clear the last result
  void clearResult() {
    state = state.copyWith(lastResult: null, error: null);
  }
}

/// Receipt OCR Provider
final receiptOcrProvider =
    NotifierProvider<ReceiptOcrNotifier, ReceiptOcrState>(
      ReceiptOcrNotifier.new,
    );

/// Common grocery categories for Bangladesh
class ReceiptCategories {
  static const Map<String, List<String>> categoryKeywords = {
    'vegetables': [
      'potato',
      'onion',
      'tomato',
      'carrot',
      'cabbage',
      'cauliflower',
      'brinjal',
      'eggplant',
      'cucumber',
      'pumpkin',
      'gourd',
      'spinach',
      'আলু',
      'পেঁয়াজ',
      'টমেটো',
    ],
    'fish': [
      'fish',
      'hilsa',
      'rui',
      'katla',
      'tilapia',
      'shrimp',
      'prawn',
      'মাছ',
      'ইলিশ',
      'রুই',
      'চিংড়ি',
    ],
    'meat': [
      'chicken',
      'mutton',
      'beef',
      'meat',
      'egg',
      'মুরগি',
      'খাসি',
      'গরু',
      'ডিম',
    ],
    'rice': ['rice', 'চাল', 'basmati', 'miniket'],
    'oil': ['oil', 'soybean', 'mustard', 'তেল', 'সয়াবিন', 'সরিষা'],
    'spices': [
      'salt',
      'sugar',
      'chili',
      'turmeric',
      'cumin',
      'coriander',
      'লবণ',
      'চিনি',
      'মরিচ',
      'হলুদ',
      'জিরা',
      'ধনে',
    ],
    'dairy': ['milk', 'ghee', 'butter', 'cheese', 'দুধ', 'ঘি'],
    'groceries': [], // Default category
  };

  /// Get category for an item name
  static String categorize(String itemName) {
    final lower = itemName.toLowerCase();

    for (final entry in categoryKeywords.entries) {
      if (entry.value.any((keyword) => lower.contains(keyword))) {
        return entry.key;
      }
    }

    return 'groceries';
  }
}
