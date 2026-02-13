import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/effects/shimmer_effect.dart' as skeleton;
import 'package:gap/gap.dart';

import 'package:mess_manager/core/theme/app_theme.dart';

/// Skeleton Widgets using Skeletonizer package
/// Usage: Wrap any widget tree with Skeletonizer(enabled: isLoading, child: ...)

/// Skeleton theme for consistent styling
class SkeletonConfig {
  static SkeletonizerConfigData get theme => SkeletonizerConfigData(
    effect: skeleton.ShimmerEffect(
      baseColor: AppColors.cardDark,
      highlightColor: AppColors.surfaceDark.withValues(alpha: 0.8),
      duration: const Duration(milliseconds: 1500),
    ),
    enableSwitchAnimation: true,
    switchAnimationConfig: const SwitchAnimationConfig(
      duration: Duration(milliseconds: 300),
    ),
  );
}

/// Card skeleton for list items
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(children: [
        // Avatar placeholder
        const Bone.circle(size: 48),
        const Gap(12),
        // Content placeholders
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Bone.text(words: 2),
            const Gap(8),
            const Bone.text(words: 4, fontSize: 12),
          ]),
        ),
        // Value placeholder
        const Bone.text(words: 1, fontSize: 18),
      ]),
    );
  }
}

/// Member card skeleton
class SkeletonMemberCard extends StatelessWidget {
  const SkeletonMemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(children: [
        const Bone.circle(size: 48),
        const Gap(12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Bone.text(words: 2),
            const Gap(8),
            Row(children: [
              Bone.square(size: 20, borderRadius: BorderRadius.circular(4)),
              const Gap(8),
              const Bone.text(words: 1, fontSize: 12),
            ]),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          const Bone.text(words: 1, fontSize: 16),
          const Gap(4),
          const Bone.text(words: 1, fontSize: 10),
        ]),
      ]),
    );
  }
}

/// Stats card skeleton
class SkeletonStatsCard extends StatelessWidget {
  const SkeletonStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Bone.square(size: 24, borderRadius: BorderRadius.circular(4)),
          const Gap(8),
          const Bone.text(words: 2, fontSize: 12),
        ]),
        const Gap(12),
        const Bone.text(words: 1, fontSize: 24),
        const Gap(4),
        const Bone.text(words: 2, fontSize: 10),
      ]),
    );
  }
}

/// List skeleton (multiple cards)
class SkeletonList extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index)? itemBuilder;

  const SkeletonList({super.key, this.itemCount = 5, this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: skeleton.ShimmerEffect(
        baseColor: context.cardColor,
        highlightColor: context.surfaceColor.withValues(alpha: 0.8),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: itemCount,
        itemBuilder: (context, index) =>
            itemBuilder?.call(index) ?? const SkeletonCard(),
      ),
    );
  }
}

/// Dashboard skeleton
class SkeletonDashboard extends StatelessWidget {
  const SkeletonDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: skeleton.ShimmerEffect(
        baseColor: context.cardColor,
        highlightColor: context.surfaceColor.withValues(alpha: 0.8),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Stats row
            Row(children: [
              const Expanded(child: SkeletonStatsCard()),
              const Gap(AppSpacing.md),
              const Expanded(child: SkeletonStatsCard()),
            ]),
            const Gap(AppSpacing.md),
            Row(children: [
              const Expanded(child: SkeletonStatsCard()),
              const Gap(AppSpacing.md),
              const Expanded(child: SkeletonStatsCard()),
            ]),
            const Gap(AppSpacing.lg),
            // Recent items
            ...List.generate(3, (_) => const SkeletonCard()),
          ],
        ),
      ),
    );
  }
}
