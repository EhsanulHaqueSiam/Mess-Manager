import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:mess_manager/core/models/mess_ad.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/features/mess_search/widgets/image_carousel.dart';

/// Card displaying a mess advertisement in the search listing.
class MessAdCard extends StatelessWidget {
  final MessAd ad;
  final VoidCallback? onTap;

  const MessAdCard({
    super.key,
    required this.ad,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.lightTap();
        onTap?.call();
      },
      child: AnimatedScale(
        scale: 1.0,
        duration: 150.ms,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: AppSpacing.glassTile(radius: AppSpacing.radiusLg),
          foregroundDecoration:
              AppSpacing.glassTileHighlight(radius: AppSpacing.radiusLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image carousel
              Stack(
                children: [
                  ImageCarousel(
                    imageUrls: ad.imageUrls,
                    height: 190,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.radiusLg),
                      topRight: Radius.circular(AppSpacing.radiusLg),
                    ),
                  ),

                  // Members needed badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _MembersNeededBadge(count: ad.membersNeeded),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + rent
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            ad.title,
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimaryDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (ad.rentPerPerson != null) ...[
                          const Gap(AppSpacing.sm),
                          _RentChip(rent: ad.rentPerPerson!),
                        ],
                      ],
                    ),
                    const Gap(AppSpacing.xs),

                    // Location
                    Row(
                      children: [
                        Icon(
                          LucideIcons.mapPin,
                          size: 13,
                          color: AppColors.accentAlt,
                        ),
                        const Gap(4),
                        Expanded(
                          child: Text(
                            ad.location,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondaryDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Gap(AppSpacing.sm),

                    // Description preview
                    Text(
                      ad.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMutedDark,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Gap(AppSpacing.sm),

                    // Amenities chips
                    if (ad.amenities.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: ad.amenities
                            .take(4)
                            .map((a) => _AmenityChip(label: a))
                            .toList(),
                      ),
                    const Gap(AppSpacing.sm),

                    // Footer: posted by + time
                    Row(
                      children: [
                        Icon(
                          LucideIcons.user,
                          size: 12,
                          color: AppColors.textMutedDark,
                        ),
                        const Gap(4),
                        Text(
                          ad.postedByName,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMutedDark,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          LucideIcons.clock,
                          size: 12,
                          color: AppColors.textMutedDark,
                        ),
                        const Gap(4),
                        Text(
                          _timeAgo(ad.createdAt),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMutedDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}

/// Glowing badge showing how many members are needed.
class _MembersNeededBadge extends StatelessWidget {
  final int count;
  const _MembersNeededBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final color = count == 1
        ? AppColors.accent
        : count == 2
            ? AppColors.accentAlt
            : AppColors.accentWarm;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.users, size: 13, color: color),
          const Gap(4),
          Text(
            count == 1 ? '1 seat' : '$count seats',
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small rent chip showing price per person.
class _RentChip extends StatelessWidget {
  final double rent;
  const _RentChip({required this.rent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Text(
        '৳${rent.toInt()}/mo',
        style: AppTypography.mono.copyWith(
          color: AppColors.accent,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Tiny amenity chip.
class _AmenityChip extends StatelessWidget {
  final String label;
  const _AmenityChip({required this.label});

  IconData get _icon {
    switch (label.toLowerCase()) {
      case 'wifi':
        return LucideIcons.wifi;
      case 'gas':
        return LucideIcons.flame;
      case 'water':
        return LucideIcons.droplets;
      case 'ac':
        return LucideIcons.snowflake;
      case 'security':
        return LucideIcons.shield;
      case 'lift':
        return LucideIcons.arrowUpDown;
      case 'generator':
        return LucideIcons.zap;
      case 'gym':
        return LucideIcons.dumbbell;
      case 'parking':
        return LucideIcons.car;
      case 'cook':
        return LucideIcons.chefHat;
      case 'laundry':
        return LucideIcons.shirt;
      default:
        return LucideIcons.check;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 11, color: AppColors.textSecondaryDark),
          const Gap(3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
