import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mess_manager/core/database/isar_service.dart';

/// Available theme color options with their display names
enum ThemeColorOption {
  // Primary/Default
  cosmic('Cosmic Blue', Color(0xFF6D5BFF)),

  // Warm tones
  coral('Coral Glow', Color(0xFFFF6B6B)),
  sunset('Sunset Orange', Color(0xFFFF8A3D)),
  gold('Golden Hour', Color(0xFFFFB638)),

  // Cool tones
  teal('Ocean Teal', Color(0xFF14B8A6)),
  cyan('Electric Cyan', Color(0xFF00D9FF)),
  mint('Fresh Mint', Color(0xFF10B981)),

  // Purples/Pinks
  violet('Vivid Violet', Color(0xFF8B5CF6)),
  magenta('Hot Magenta', Color(0xFFEC4899)),
  lavender('Soft Lavender', Color(0xFFA78BFA)),

  // Neutrals
  slate('Slate Gray', Color(0xFF64748B)),
  rose('Dusty Rose', Color(0xFFF43F5E)),
  emerald('Deep Emerald', Color(0xFF059669)),

  // Material You (system)
  system('System (Material You)', null);

  const ThemeColorOption(this.displayName, this.color);

  final String displayName;
  final Color? color;

  /// Get the color value, defaulting to cosmic for system
  Color get effectiveColor => color ?? cosmic.color!;
}

/// Theme color notifier using the Notifier pattern
class ThemeColorNotifier extends Notifier<ThemeColorOption> {
  static const _storageKey = 'theme_color_option';

  @override
  ThemeColorOption build() {
    return _loadInitialColor();
  }

  /// Load saved color from Isar
  static ThemeColorOption _loadInitialColor() {
    final savedIndex = IsarService.getSetting<int>(_storageKey);
    if (savedIndex == null ||
        savedIndex < 0 ||
        savedIndex >= ThemeColorOption.values.length) {
      return ThemeColorOption.cosmic; // Default
    }
    return ThemeColorOption.values[savedIndex];
  }

  /// Change the theme color and persist
  void setColor(ThemeColorOption option) {
    state = option;
    IsarService.saveSetting(_storageKey, option.index);
  }

  /// Get the current seed color for theme building
  Color get seedColor => state.effectiveColor;

  /// Check if using system/Material You colors
  bool get isUsingSystemColor => state == ThemeColorOption.system;
}

/// Provider for the current theme color seed
final themeColorProvider =
    NotifierProvider<ThemeColorNotifier, ThemeColorOption>(
      ThemeColorNotifier.new,
    );
