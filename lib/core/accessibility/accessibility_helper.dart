import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Accessibility Helper Library
///
/// Provides semantic wrappers and accessibility utilities for screen reader support.
/// Follows WCAG 2.1 AA guidelines for mobile accessibility.
///
/// Key features:
/// - SemanticButton: Buttons with proper labels and hints
/// - SemanticCard: Cards with grouped content
/// - SemanticValue: Display values with labels for context
/// - SemanticList: Lists with item count announcements
/// - AccessibilityAnnouncement: For dynamic content changes

// ═══════════════════════════════════════════════════════════════════════════
// SEMANTIC BUTTONS
// ═══════════════════════════════════════════════════════════════════════════

/// Accessible button with semantic label
class SemanticButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String label;
  final String? hint;
  final bool isEnabled;
  final bool isDestructive;

  const SemanticButton({
    super.key,
    required this.child,
    this.onPressed,
    required this.label,
    this.hint,
    this.isEnabled = true,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled && onPressed != null,
      label: label,
      hint: hint,
      onTap: onPressed,
      child: ExcludeSemantics(child: child),
    );
  }
}

/// Accessible icon button
class SemanticIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String label;
  final String? hint;
  final Color? color;
  final double size;

  const SemanticIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    required this.label,
    this.hint,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      label: label,
      hint: hint,
      onTap: onPressed,
      child: IconButton(
        icon: Icon(icon, color: color, size: size),
        onPressed: onPressed,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEMANTIC CARDS & CONTAINERS
// ═══════════════════════════════════════════════════════════════════════════

/// Accessible card that groups related content
class SemanticCard extends StatelessWidget {
  final Widget child;
  final String? label;
  final String? hint;
  final VoidCallback? onTap;
  final bool excludeSemantics;

  const SemanticCard({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.onTap,
    this.excludeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: label,
      hint: hint,
      button: onTap != null,
      onTap: onTap,
      child: excludeSemantics ? ExcludeSemantics(child: child) : child,
    );
  }
}

/// Accessible header/section title
class SemanticHeader extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool isHeader;

  const SemanticHeader({
    super.key,
    required this.text,
    this.style,
    this.isHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: isHeader,
      child: Text(text, style: style),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEMANTIC VALUES & DATA DISPLAY
// ═══════════════════════════════════════════════════════════════════════════

/// Accessible value display with label for context
class SemanticValue extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;
  final bool horizontal;

  const SemanticValue({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final children = [
      Text(label, style: labelStyle),
      if (horizontal) const SizedBox(width: 8) else const SizedBox(height: 4),
      Text(value, style: valueStyle),
    ];

    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: horizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: children)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }
}

/// Accessible balance/amount display
class SemanticBalance extends StatelessWidget {
  final double amount;
  final String currency;
  final TextStyle? style;
  final bool showSign;

  const SemanticBalance({
    super.key,
    required this.amount,
    this.currency = '৳',
    this.style,
    this.showSign = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final sign = showSign ? (isPositive ? 'plus' : 'minus') : '';
    final absAmount = amount.abs().toStringAsFixed(0);

    return Semantics(
      label: 'Balance: $sign $absAmount taka',
      excludeSemantics: true,
      child: Text(
        '${showSign && isPositive ? '+' : ''}$currency$absAmount',
        style: style,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEMANTIC LISTS & NAVIGATION
// ═══════════════════════════════════════════════════════════════════════════

/// Accessible list item with position info
class SemanticListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final int total;
  final String? label;
  final VoidCallback? onTap;

  const SemanticListItem({
    super.key,
    required this.child,
    required this.index,
    required this.total,
    this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label != null
          ? '$label, item ${index + 1} of $total'
          : 'Item ${index + 1} of $total',
      button: onTap != null,
      onTap: onTap,
      child: child,
    );
  }
}

/// Accessible navigation destination
class SemanticNavItem extends StatelessWidget {
  final Widget child;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const SemanticNavItem({
    super.key,
    required this.child,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label${isSelected ? ', selected' : ''}',
      onTap: onTap,
      child: ExcludeSemantics(child: child),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEMANTIC FORMS
// ═══════════════════════════════════════════════════════════════════════════

/// Accessible text field
class SemanticTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;

  const SemanticTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.decoration,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      value: controller?.text,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        decoration: (decoration ?? const InputDecoration()).copyWith(
          labelText: label,
          hintText: hint,
          errorText: errorText,
        ),
      ),
    );
  }
}

/// Accessible toggle/switch
class SemanticSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String label;
  final String? onLabel;
  final String? offLabel;

  const SemanticSwitch({
    super.key,
    required this.value,
    this.onChanged,
    required this.label,
    this.onLabel,
    this.offLabel,
  });

  @override
  Widget build(BuildContext context) {
    final stateLabel = value ? (onLabel ?? 'on') : (offLabel ?? 'off');

    return Semantics(
      toggled: value,
      label: '$label, $stateLabel',
      hint: 'Double tap to toggle',
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ACCESSIBILITY ANNOUNCEMENTS
// ═══════════════════════════════════════════════════════════════════════════

/// Announce a message to screen readers
void announceToScreenReader(BuildContext context, String message) {
  SemanticsService.announce(message, TextDirection.ltr);
}

/// Announce live region updates
class LiveRegion extends StatelessWidget {
  final Widget child;
  final String? announcement;

  const LiveRegion({super.key, required this.child, this.announcement});

  @override
  Widget build(BuildContext context) {
    return Semantics(liveRegion: true, label: announcement, child: child);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ACCESSIBILITY EXTENSIONS
// ═══════════════════════════════════════════════════════════════════════════

/// Extension to add accessibility to any widget
extension AccessibilityExtension on Widget {
  /// Wrap with semantic label
  Widget withSemanticLabel(String label, {String? hint}) {
    return Semantics(label: label, hint: hint, child: this);
  }

  /// Mark as button
  Widget asSemanticButton(String label, {VoidCallback? onTap}) {
    return Semantics(
      button: true,
      label: label,
      onTap: onTap,
      child: ExcludeSemantics(child: this),
    );
  }

  /// Mark as header
  Widget asSemanticHeader() {
    return Semantics(header: true, child: this);
  }

  /// Mark as image with description
  Widget asSemanticImage(String description) {
    return Semantics(
      image: true,
      label: description,
      child: ExcludeSemantics(child: this),
    );
  }

  /// Exclude from semantics
  Widget excludeSemantics() {
    return ExcludeSemantics(child: this);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ACCESSIBILITY CHECKER (Debug helper)
// ═══════════════════════════════════════════════════════════════════════════

/// Debug widget to highlight accessibility issues
class AccessibilityDebugOverlay extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AccessibilityDebugOverlay({
    super.key,
    required this.child,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    // In debug mode, show semantics debugger
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SemanticsDebugger(child: child),
    );
  }
}
