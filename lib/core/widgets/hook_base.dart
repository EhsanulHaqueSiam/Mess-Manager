import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Base class for hook-based consumer widgets
/// Provides common hooks and utilities for cleaner state management
///
/// Benefits of using HookConsumerWidget:
/// - No need for StatefulWidget boilerplate
/// - Controllers are auto-disposed
/// - Cleaner code with useMemoized, useEffect, etc.
///
/// Example:
/// ```dart
/// class MyScreen extends HookConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final textController = useTextEditingController();
///     final focusNode = useFocusNode();
///     final animController = useAnimationController(duration: 300.ms);
///
///     useEffect(() {
///       // Runs once on mount
///       return () {
///         // Cleanup on dispose
///       };
///     }, []);
///
///     return TextField(controller: textController, focusNode: focusNode);
///   }
/// }
/// ```

// ═══════════════════════════════════════════════════════════════════════════
// CUSTOM HOOKS
// ═══════════════════════════════════════════════════════════════════════════

/// Debounced search hook
/// Returns a debounced value that updates after the delay
T useDebouncedValue<T>(T value, Duration delay) {
  final debouncedValue = useState(value);

  useEffect(() {
    final timer = Future.delayed(delay, () {
      debouncedValue.value = value;
    });
    return () => timer.ignore();
  }, [value]);

  return debouncedValue.value;
}

/// Form validation hook
/// Returns validation state and methods
({bool isValid, String? error, void Function() validate}) useFormValidation({
  required String value,
  required bool Function(String) validator,
  String? errorMessage,
}) {
  final error = useState<String?>(null);
  final isValid = useState(false);

  void validate() {
    if (validator(value)) {
      isValid.value = true;
      error.value = null;
    } else {
      isValid.value = false;
      error.value = errorMessage ?? 'Invalid input';
    }
  }

  return (isValid: isValid.value, error: error.value, validate: validate);
}

/// Toggle state hook
/// Simple boolean toggle with callback
({bool value, void Function() toggle, void Function(bool) set}) useToggle([
  bool initial = false,
]) {
  final state = useState(initial);
  return (
    value: state.value,
    toggle: () => state.value = !state.value,
    set: (v) => state.value = v,
  );
}

/// Loading state hook
/// Manages loading state for async operations
({bool isLoading, Future<T> Function<T>(Future<T> Function()) wrap})
useLoadingState() {
  final isLoading = useState(false);

  Future<T> wrap<T>(Future<T> Function() asyncFn) async {
    isLoading.value = true;
    try {
      return await asyncFn();
    } finally {
      isLoading.value = false;
    }
  }

  return (isLoading: isLoading.value, wrap: wrap);
}

/// Mounted check hook
/// Returns a function to check if widget is still mounted
bool Function() useIsMounted() {
  final isMounted = useRef(true);

  useEffect(() {
    return () => isMounted.value = false;
  }, []);

  return () => isMounted.value;
}

/// Previous value hook
/// Returns the previous value of a variable
T? usePrevious<T>(T value) {
  final ref = useRef<T?>(null);

  useEffect(() {
    ref.value = value;
  });

  return ref.value;
}

// ═══════════════════════════════════════════════════════════════════════════
// ANIMATION HOOKS
// ═══════════════════════════════════════════════════════════════════════════

/// Fade animation hook
/// Returns an animation value for fade effects
Animation<double> useFadeAnimation({
  Duration duration = const Duration(milliseconds: 300),
  bool autoStart = true,
}) {
  final controller = useAnimationController(duration: duration);
  final animation = useAnimation(
    CurvedAnimation(parent: controller, curve: Curves.easeOut),
  );

  useEffect(() {
    if (autoStart) {
      controller.forward();
    }
    return null;
  }, []);

  return animation as Animation<double>;
}

/// Slide animation hook
/// Returns an animation value for slide effects
Animation<Offset> useSlideAnimation({
  Duration duration = const Duration(milliseconds: 300),
  Offset begin = const Offset(0, 0.1),
  Offset end = Offset.zero,
  bool autoStart = true,
}) {
  final controller = useAnimationController(duration: duration);
  final animation = Tween<Offset>(
    begin: begin,
    end: end,
  ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

  useEffect(() {
    if (autoStart) {
      controller.forward();
    }
    return null;
  }, []);

  return animation;
}

// ═══════════════════════════════════════════════════════════════════════════
// TAB CONTROLLER HOOK
// ═══════════════════════════════════════════════════════════════════════════

/// Tab controller hook with vsync
TabController useTabController({
  required int initialLength,
  int initialIndex = 0,
  required TickerProvider vsync,
}) {
  return useMemoized(
    () => TabController(
      length: initialLength,
      vsync: vsync,
      initialIndex: initialIndex,
    ),
    [initialLength],
  );
}
