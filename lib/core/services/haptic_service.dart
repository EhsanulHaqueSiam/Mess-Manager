import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

/// Premium Haptic Feedback Service
/// Provides semantic tactile feedback using haptic_feedback library
/// Falls back to HapticFeedback when library not available
class HapticService {
  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC IMPACTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Light tap - for button presses, toggles
  static Future<void> lightTap() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.light);
    } else {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium tap - for selections, confirms
  static Future<void> mediumTap() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.medium);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// Heavy tap - for important actions, deletes
  static Future<void> heavyTap() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.heavy);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  /// Selection tick - for scroll selections, pickers
  static Future<void> selectionTick() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.selection);
    } else {
      HapticFeedback.selectionClick();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC HAPTICS (haptic_feedback library)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Success - completed actions, confirmations
  static Future<void> success() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.success);
    } else {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.lightImpact();
    }
  }

  /// Error - failed actions, validation errors
  static Future<void> error() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.error);
    } else {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 80));
      HapticFeedback.heavyImpact();
    }
  }

  /// Warning - caution, attention needed
  static Future<void> warning() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.warning);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UI INTERACTION HAPTICS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Soft pulse - for hover/focus states
  static Future<void> softPulse() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.soft);
    } else {
      HapticFeedback.selectionClick();
    }
  }

  /// Button press - optimized for button interactions
  static Future<void> buttonPress() async {
    await lightTap();
  }

  /// Toggle switch
  static Future<void> toggle() async {
    await selectionTick();
  }

  /// Swipe action triggered
  static Future<void> swipe() async {
    await mediumTap();
  }

  /// Pull to refresh triggered
  static Future<void> pullToRefresh() async {
    final canVibrate = await Haptics.canVibrate();
    if (canVibrate) {
      await Haptics.vibrate(HapticsType.rigid);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// Long press started
  static Future<void> longPressStart() async {
    await selectionTick();
  }

  /// Long press ended
  static Future<void> longPressEnd() async {
    await lightTap();
  }

  /// Navigation - screen transition
  static Future<void> navigation() async {
    await selectionTick();
  }

  /// Modal/sheet opened
  static Future<void> modalOpen() async {
    await lightTap();
  }

  /// Modal/sheet closed
  static Future<void> modalClose() async {
    await selectionTick();
  }

  /// Item added
  static Future<void> itemAdded() async {
    await success();
  }

  /// Item deleted
  static Future<void> itemDeleted() async {
    await heavyTap();
  }

  /// Scroll snap
  static Future<void> scrollSnap() async {
    await selectionTick();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Double tap pattern
  static Future<void> doubleTap() async {
    await lightTap();
    await Future.delayed(const Duration(milliseconds: 50));
    await lightTap();
  }

  /// Triple success pattern (for big wins)
  static Future<void> celebrate() async {
    await lightTap();
    await Future.delayed(const Duration(milliseconds: 100));
    await mediumTap();
    await Future.delayed(const Duration(milliseconds: 100));
    await success();
  }
}
