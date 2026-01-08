import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:haptic_feedback/haptic_feedback.dart';
import 'package:flutter_advanced_haptic/flutter_advanced_haptic.dart';

/// Premium Haptic Feedback Service - Android 16 Style
///
/// Uses flutter_advanced_haptic for premium custom patterns and intensity control.
/// Provides progressive intensity (like volume slider), bouncy feedback,
/// and tactile feel everywhere.
///
/// Key Android 16-style features:
/// - Progressive intensity: haptics grow stronger as value increases
/// - Bouncy feedback: elastic, satisfying bounce on interactions
/// - Scroll haptics: subtle feedback at scroll boundaries
/// - Micro-tactile: tiny feedback on every small interaction
class HapticService {
  // Singleton instance
  static final FlutterHaptic _haptic = FlutterHaptic.instance;

  // Cache vibration support check
  static bool? _canVibrate;
  static bool? _supportsIntensity;

  // Track last haptic time to prevent spam
  static DateTime? _lastHapticTime;
  static const _minHapticInterval = Duration(milliseconds: 30);

  /// Check and cache if device supports haptics
  static Future<bool> _checkVibrationSupport() async {
    if (kIsWeb) return false;
    _canVibrate ??= await _haptic.isSupported();
    return _canVibrate!;
  }

  /// Check if device supports intensity control
  static Future<bool> _checkIntensitySupport() async {
    if (kIsWeb) return false;
    _supportsIntensity ??= await _haptic.supportsIntensity();
    return _supportsIntensity!;
  }

  /// Throttle haptics to prevent spam
  static bool _shouldThrottle() {
    final now = DateTime.now();
    if (_lastHapticTime != null &&
        now.difference(_lastHapticTime!) < _minHapticInterval) {
      return true;
    }
    _lastHapticTime = now;
    return false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANDROID 16 STYLE: PROGRESSIVE INTENSITY
  // Volume slider style - intensity grows with value
  // ═══════════════════════════════════════════════════════════════════════════

  /// Progressive intensity based on value (0.0 to 1.0)
  /// Perfect for sliders, volume controls, brightness adjustments
  /// Haptic gets stronger as value increases - like Android 16 volume
  static Future<void> progressiveIntensity(double value) async {
    if (_shouldThrottle()) return;
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }

    // Clamp value between 0.0 and 1.0
    final clampedValue = value.clamp(0.0, 1.0);

    if (await _checkIntensitySupport()) {
      // Map value to intensity (0.1 to 0.9) - never silent, never too harsh
      final intensity = 0.1 + (clampedValue * 0.8);
      // Duration also scales slightly with intensity
      final duration = (5 + (clampedValue * 10)).round();

      await _haptic.vibrate(intensity: intensity, duration: duration);
    } else {
      // Fallback: use different strengths
      if (clampedValue < 0.3) {
        await _haptic.short();
      } else if (clampedValue < 0.7) {
        await _haptic.light();
      } else {
        await _haptic.medium();
      }
    }
  }

  /// Slider step tick - for discrete slider values
  /// Use when slider snaps to specific values
  static Future<void> sliderStep(int step, int maxSteps) async {
    if (_shouldThrottle()) return;
    final value = step / maxSteps.clamp(1, 100);
    await progressiveIntensity(value);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANDROID 16 STYLE: BOUNCY FEEDBACK
  // Elastic, satisfying bounce on interactions
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bouncy tap - elastic feel on press
  /// Two quick taps with the second slightly softer (bounce back)
  static Future<void> bouncyTap() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.lightImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.playPattern(
        HapticPattern([
          HapticEvent.vibrate(duration: 12, intensity: 0.5),
          HapticEvent.pause(30),
          HapticEvent.vibrate(duration: 8, intensity: 0.25), // bounce back
        ]),
      );
    } else {
      await _haptic.playPattern(HapticPattern.doubleTap());
    }
  }

  /// Bouncy confirm - stronger bounce with confirmation feel
  /// Perfect for confirmations, toggles, important selections
  static Future<void> bouncyConfirm() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.mediumImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.playPattern(
        HapticPattern([
          HapticEvent.vibrate(duration: 20, intensity: 0.6),
          HapticEvent.pause(40),
          HapticEvent.vibrate(duration: 15, intensity: 0.35),
          HapticEvent.pause(30),
          HapticEvent.vibrate(duration: 8, intensity: 0.15), // final bounce
        ]),
      );
    } else {
      await _haptic.success();
    }
  }

  /// Bouncy error - attention-grabbing bounce pattern
  static Future<void> bouncyError() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.heavyImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.playPattern(
        HapticPattern([
          HapticEvent.vibrate(duration: 30, intensity: 0.8),
          HapticEvent.pause(50),
          HapticEvent.vibrate(duration: 25, intensity: 0.6),
          HapticEvent.pause(40),
          HapticEvent.vibrate(duration: 20, intensity: 0.4),
        ]),
      );
    } else {
      await _haptic.error();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ANDROID 16 STYLE: SCROLL & LIST HAPTICS
  // Subtle feedback during scrolling
  // ═══════════════════════════════════════════════════════════════════════════

  /// Scroll edge reached - bouncy overscroll feel
  static Future<void> scrollEdge() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.4, duration: 15);
    } else {
      await _haptic.medium();
    }
  }

  /// Scroll item snap - for paged scrolling, carousels
  static Future<void> scrollItemSnap() async {
    if (_shouldThrottle()) return;
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.25, duration: 8);
    } else {
      await _haptic.short();
    }
  }

  /// Refresh triggered - pull to refresh activated
  static Future<void> refreshTriggered() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.mediumImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.playPattern(
        HapticPattern([
          HapticEvent.vibrate(duration: 10, intensity: 0.3),
          HapticEvent.pause(20),
          HapticEvent.vibrate(duration: 20, intensity: 0.5),
        ]),
      );
    } else {
      await _haptic.medium();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC IMPACTS - Premium tuned
  // ═══════════════════════════════════════════════════════════════════════════

  /// Light tap - for button presses, toggles, minor interactions
  static Future<void> lightTap() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.lightImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.3, duration: 10);
    } else {
      await _haptic.light();
    }
  }

  /// Medium tap - for selections, confirms, important actions
  static Future<void> mediumTap() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.mediumImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.5, duration: 20);
    } else {
      await _haptic.medium();
    }
  }

  /// Heavy tap - for important actions, deletes, confirms
  static Future<void> heavyTap() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.heavyImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.8, duration: 40);
    } else {
      await _haptic.heavy();
    }
  }

  /// Selection tick - for scroll selections, pickers, tabs
  static Future<void> selectionTick() async {
    if (_shouldThrottle()) return;
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.2, duration: 5);
    } else {
      await _haptic.short();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC HAPTICS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Success - completed actions
  static Future<void> success() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.mediumImpact();
      return;
    }
    await _haptic.success();
  }

  /// Error - failed actions
  static Future<void> error() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.heavyImpact();
      return;
    }
    await _haptic.error();
  }

  /// Warning - caution needed
  static Future<void> warning() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.mediumImpact();
      return;
    }
    await _haptic.warning();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MICRO-INTERACTIONS - Ultra-subtle tactile feel
  // ═══════════════════════════════════════════════════════════════════════════

  /// Micro tick - tiniest possible haptic for frequent interactions
  static Future<void> microTick() async {
    if (_shouldThrottle()) return;
    if (!await _checkVibrationSupport()) return; // Skip fallback for micro

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.1, duration: 3);
    }
  }

  /// Soft pulse - for hover/focus states
  static Future<void> softPulse() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.15, duration: 8);
    } else {
      await _haptic.short();
    }
  }

  /// Button press - uses bouncy tap for premium feel
  static Future<void> buttonPress() async {
    await bouncyTap();
  }

  /// Toggle switch - double tap pattern
  static Future<void> toggle() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }
    await _haptic.playPattern(HapticPattern.doubleTap());
  }

  /// Swipe action triggered
  static Future<void> swipe() async {
    await mediumTap();
  }

  /// Pull to refresh triggered
  static Future<void> pullToRefresh() async {
    await refreshTriggered();
  }

  /// Long press started
  static Future<void> longPressStart() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.25, duration: 15);
    } else {
      await _haptic.short();
    }
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
    if (!await _checkVibrationSupport()) {
      HapticFeedback.lightImpact();
      return;
    }
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.35, duration: 12);
    } else {
      await _haptic.light();
    }
  }

  /// Modal/sheet closed
  static Future<void> modalClose() async {
    await selectionTick();
  }

  /// Item added successfully
  static Future<void> itemAdded() async {
    await bouncyConfirm();
  }

  /// Item deleted
  static Future<void> itemDeleted() async {
    await heavyTap();
  }

  /// Scroll snap
  static Future<void> scrollSnap() async {
    await scrollItemSnap();
  }

  /// Slider value changed
  static Future<void> sliderTick() async {
    if (_shouldThrottle()) return;
    if (!await _checkVibrationSupport()) return;
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.1, duration: 5);
    }
  }

  /// Number input +/- buttons
  static Future<void> numberTick() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.25, duration: 8);
    } else {
      await _haptic.short();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL PATTERNS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Double tap pattern
  static Future<void> doubleTap() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      HapticFeedback.lightImpact();
      return;
    }
    await _haptic.playPattern(HapticPattern.doubleTap());
  }

  /// Triple tap pattern
  static Future<void> tripleTap() async {
    if (!await _checkVibrationSupport()) {
      for (int i = 0; i < 3; i++) {
        HapticFeedback.lightImpact();
        if (i < 2) await Future.delayed(const Duration(milliseconds: 50));
      }
      return;
    }
    await _haptic.playPattern(HapticPattern.tripleTap());
  }

  /// Heartbeat pattern
  static Future<void> heartbeat() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      HapticFeedback.lightImpact();
      return;
    }
    await _haptic.playPattern(HapticPattern.heartbeat());
  }

  /// Celebration pattern - rising intensity for achievements
  static Future<void> celebrate() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.heavyImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.playPattern(
        HapticPattern([
          HapticEvent.vibrate(duration: 15, intensity: 0.3),
          HapticEvent.pause(40),
          HapticEvent.vibrate(duration: 20, intensity: 0.5),
          HapticEvent.pause(40),
          HapticEvent.vibrate(duration: 30, intensity: 0.7),
          HapticEvent.pause(60),
          HapticEvent.vibrate(duration: 40, intensity: 1.0),
        ]),
      );
    } else {
      await _haptic.success();
    }
  }

  /// Payment confirmed
  static Future<void> paymentConfirmed() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
      HapticFeedback.heavyImpact();
      return;
    }

    if (await _checkIntensitySupport()) {
      await _haptic.playPattern(
        HapticPattern([
          HapticEvent.vibrate(duration: 25, intensity: 0.4),
          HapticEvent.pause(100),
          HapticEvent.vibrate(duration: 35, intensity: 0.7),
        ]),
      );
    } else {
      await _haptic.success();
    }
  }

  /// Data saved
  static Future<void> dataSaved() async {
    await success();
  }

  /// Notification received
  static Future<void> notificationReceived() async {
    await heartbeat();
  }

  /// Undo available
  static Future<void> undoAvailable() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.lightImpact();
      return;
    }
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.3, duration: 15);
    } else {
      await _haptic.light();
    }
  }

  /// Timer/countdown tick
  static Future<void> countdownTick() async {
    if (!await _checkVibrationSupport()) {
      HapticFeedback.selectionClick();
      return;
    }
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.4, duration: 10);
    } else {
      await _haptic.short();
    }
  }

  /// Tab changed - navigation between tabs
  static Future<void> tabChanged() async {
    await bouncyTap();
  }

  /// Checkbox toggled
  static Future<void> checkboxToggle() async {
    await bouncyTap();
  }

  /// Radio button selected
  static Future<void> radioSelect() async {
    await bouncyTap();
  }

  /// Dropdown opened
  static Future<void> dropdownOpen() async {
    await modalOpen();
  }

  /// Dropdown item selected
  static Future<void> dropdownSelect() async {
    await bouncyConfirm();
  }

  /// Text field focused
  static Future<void> textFieldFocus() async {
    await microTick();
  }

  /// Keyboard key pressed (for custom keyboards)
  static Future<void> keyPress() async {
    if (_shouldThrottle()) return;
    if (!await _checkVibrationSupport()) return;
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.15, duration: 5);
    }
  }

  /// Date/time picker value changed
  static Future<void> pickerScroll() async {
    if (_shouldThrottle()) return;
    if (!await _checkVibrationSupport()) return;
    if (await _checkIntensitySupport()) {
      await _haptic.vibrate(intensity: 0.12, duration: 4);
    }
  }
}
