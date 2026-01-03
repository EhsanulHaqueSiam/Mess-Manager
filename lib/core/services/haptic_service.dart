import 'package:flutter/services.dart';

/// Premium Haptic Feedback Service
/// Provides tactile feedback similar to OpenAI app experience
class HapticService {
  /// Light tap - for button presses, toggles
  static void lightTap() {
    HapticFeedback.lightImpact();
  }

  /// Medium tap - for selections, confirms
  static void mediumTap() {
    HapticFeedback.mediumImpact();
  }

  /// Heavy tap - for important actions, deletes
  static void heavyTap() {
    HapticFeedback.heavyImpact();
  }

  /// Selection tick - for scroll selections, pickers
  static void selectionTick() {
    HapticFeedback.selectionClick();
  }

  /// Success vibration - for completed actions
  static void success() {
    HapticFeedback.mediumImpact();
    Future.delayed(const Duration(milliseconds: 100), () {
      HapticFeedback.lightImpact();
    });
  }

  /// Error vibration - for failed actions
  static void error() {
    HapticFeedback.heavyImpact();
    Future.delayed(const Duration(milliseconds: 80), () {
      HapticFeedback.heavyImpact();
    });
  }

  /// Warning vibration
  static void warning() {
    HapticFeedback.mediumImpact();
  }

  /// Soft pulse - for hover/focus states
  static void softPulse() {
    HapticFeedback.selectionClick();
  }

  /// Button press - optimized for button interactions
  static void buttonPress() {
    HapticFeedback.lightImpact();
  }

  /// Toggle switch
  static void toggle() {
    HapticFeedback.selectionClick();
  }

  /// Swipe action triggered
  static void swipe() {
    HapticFeedback.mediumImpact();
  }

  /// Pull to refresh triggered
  static void pullToRefresh() {
    HapticFeedback.mediumImpact();
  }

  /// Long press started
  static void longPressStart() {
    HapticFeedback.selectionClick();
  }

  /// Long press ended
  static void longPressEnd() {
    HapticFeedback.lightImpact();
  }

  /// Navigation - screen transition
  static void navigation() {
    HapticFeedback.selectionClick();
  }

  /// Modal/sheet opened
  static void modalOpen() {
    HapticFeedback.lightImpact();
  }

  /// Modal/sheet closed
  static void modalClose() {
    HapticFeedback.selectionClick();
  }

  /// Item added
  static void itemAdded() {
    HapticFeedback.mediumImpact();
  }

  /// Item deleted
  static void itemDeleted() {
    HapticFeedback.heavyImpact();
  }

  /// Scroll snap
  static void scrollSnap() {
    HapticFeedback.selectionClick();
  }
}
