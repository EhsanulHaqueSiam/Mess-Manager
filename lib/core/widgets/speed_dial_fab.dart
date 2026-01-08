import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

/// Speed Dial FAB for quick access to common actions
class SpeedDialFAB extends StatefulWidget {
  final List<SpeedDialItem> items;
  final IconData mainIcon;
  final IconData openIcon;

  const SpeedDialFAB({
    super.key,
    required this.items,
    this.mainIcon = LucideIcons.plus,
    this.openIcon = LucideIcons.x,
  });

  @override
  State<SpeedDialFAB> createState() => _SpeedDialFABState();
}

class _SpeedDialFABState extends State<SpeedDialFAB>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.125,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticService.buttonPress();
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _close() {
    if (_isOpen) {
      setState(() => _isOpen = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Backdrop
        if (_isOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              child: Container(color: Colors.black26),
            ).animate().fadeIn(duration: 150.ms),
          ),

        // Speed dial items
        ..._buildItems(),

        // Main FAB
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: AppColors.primary,
          child: RotationTransition(
            turns: _rotateAnimation,
            child: Icon(_isOpen ? widget.openIcon : widget.mainIcon, size: 24),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildItems() {
    if (!_isOpen) return [];

    return List.generate(widget.items.length, (index) {
      final item = widget.items[index];
      final delay = (index * 50).ms;
      final bottom = 72.0 + (index * 60);

      return Positioned(
        bottom: bottom,
        right: 4,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: item.label.text.sm.color(AppColors.textPrimaryDark).make(),
            ),
            const SizedBox(width: 12),
            // Mini FAB
            FloatingActionButton.small(
              heroTag: 'speed_dial_$index',
              onPressed: () {
                HapticService.lightTap();
                _close();
                item.onPressed();
              },
              backgroundColor: item.color,
              child: Icon(item.icon, size: 20),
            ),
          ],
        ).animate(delay: delay).fadeIn().slideY(begin: 0.3),
      );
    });
  }
}

/// Speed dial item configuration
class SpeedDialItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const SpeedDialItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });
}
