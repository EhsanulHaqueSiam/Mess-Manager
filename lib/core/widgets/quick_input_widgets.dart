import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';

// ═══════════════════════════════════════════════════════════════════════════
// QUICK AMOUNT PICKER — One-tap preset amounts with custom input
// ═══════════════════════════════════════════════════════════════════════════

class QuickAmountPicker extends StatelessWidget {
  final double? selectedAmount;
  final ValueChanged<double> onAmountSelected;
  final Color accentColor;
  final List<int> presets;
  final TextEditingController? controller;

  const QuickAmountPicker({
    super.key,
    this.selectedAmount,
    required this.onAmountSelected,
    this.accentColor = AppColors.bazarColor,
    this.presets = const [100, 200, 500, 1000, 2000, 5000],
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: presets.map((amount) {
        final isSelected = selectedAmount == amount.toDouble();
        return GestureDetector(
          onTap: () {
            HapticService.selectionTick();
            onAmountSelected(amount.toDouble());
            controller?.text = amount.toString();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.2)
                  : context.cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : context.borderColor.withValues(alpha: 0.3),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              '৳$amount',
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? accentColor : context.textSecondary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MEMBER AVATAR PICKER — Horizontal scroll avatars replace dropdown
// ═══════════════════════════════════════════════════════════════════════════

class MemberAvatarPicker extends StatelessWidget {
  final List<dynamic> members;
  final String? selectedMemberId;
  final ValueChanged<String> onMemberSelected;
  final Color accentColor;
  final String? excludeMemberId;

  const MemberAvatarPicker({
    super.key,
    required this.members,
    this.selectedMemberId,
    required this.onMemberSelected,
    this.accentColor = AppColors.primary,
    this.excludeMemberId,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = excludeMemberId != null
        ? members.where((m) => m.id != excludeMemberId).toList()
        : members;

    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const Gap(10),
        itemBuilder: (context, index) {
          final member = filtered[index];
          final isSelected = selectedMemberId == member.id;

          return GestureDetector(
            onTap: () {
              HapticService.selectionTick();
              onMemberSelected(member.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 60,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: isSelected
                          ? LinearGradient(colors: [
                              accentColor,
                              accentColor.withValues(alpha: 0.7),
                            ])
                          : null,
                      color: isSelected
                          ? null
                          : context.cardColor,
                      border: Border.all(
                        color: isSelected
                            ? accentColor
                            : context.borderColor.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: -2,
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        member.name.isNotEmpty
                            ? member.name[0].toUpperCase()
                            : '?',
                        style: AppTypography.titleMedium.copyWith(
                          color: isSelected
                              ? Colors.white
                              : context.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    _firstName(member.name),
                    style: AppTypography.labelSmall.copyWith(
                      color: isSelected
                          ? accentColor
                          : context.textMuted,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _firstName(String name) {
    final parts = name.split(' ');
    return parts.first;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// QUICK DURATION PICKER — One-tap duration presets for vacation
// ═══════════════════════════════════════════════════════════════════════════

class QuickDurationPicker extends StatelessWidget {
  final int? selectedDays;
  final ValueChanged<int> onDurationSelected;
  final Color accentColor;

  const QuickDurationPicker({
    super.key,
    this.selectedDays,
    required this.onDurationSelected,
    this.accentColor = AppColors.success,
  });

  static const _presets = [
    (1, 'Tomorrow'),
    (3, '3 days'),
    (7, '1 week'),
    (14, '2 weeks'),
    (30, '1 month'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _presets.map((preset) {
        final (days, label) = preset;
        final isSelected = selectedDays == days;
        return GestureDetector(
          onTap: () {
            HapticService.selectionTick();
            onDurationSelected(days);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : Colors.white.withValues(alpha: 0.08),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: isSelected ? accentColor : Colors.white.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INLINE MEAL COUNTER — Dashboard inline meal toggle
// ═══════════════════════════════════════════════════════════════════════════

class InlineMealCounter extends StatelessWidget {
  final int count;
  final ValueChanged<int> onCountChanged;
  final int maxCount;
  final Color accentColor;

  const InlineMealCounter({
    super.key,
    required this.count,
    required this.onCountChanged,
    this.maxCount = 10,
    this.accentColor = AppColors.mealColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: accentColor.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Icon(LucideIcons.utensils, color: accentColor, size: 18),
              const Gap(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s meals',
                      style: AppTypography.labelSmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    Text(
                      '$count meal${count != 1 ? 's' : ''}',
                      style: AppTypography.titleSmall.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              // Quick preset chips
              ...[0, 2, 3].map((preset) {
                final isActive = count == preset;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: GestureDetector(
                    onTap: () {
                      HapticService.selectionTick();
                      onCountChanged(preset);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isActive
                            ? accentColor
                            : Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isActive
                              ? accentColor
                              : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          preset == 0 ? 'Off' : '$preset',
                          style: AppTypography.labelMedium.copyWith(
                            color: isActive
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w700,
                            fontSize: preset == 0 ? 10 : 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// DESCRIPTION SUGGEST CHIPS — Quick-tap common descriptions
// ═══════════════════════════════════════════════════════════════════════════

class DescriptionSuggestChips extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String> onSelected;
  final Color accentColor;

  const DescriptionSuggestChips({
    super.key,
    required this.suggestions,
    required this.onSelected,
    this.accentColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: suggestions.map((s) {
        return GestureDetector(
          onTap: () {
            HapticService.lightTap();
            onSelected(s);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              s,
              style: AppTypography.labelSmall.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
