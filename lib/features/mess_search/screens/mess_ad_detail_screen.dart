import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:mess_manager/core/models/mess_ad.dart';
import 'package:mess_manager/core/theme/app_theme.dart';
import 'package:mess_manager/core/services/haptic_service.dart';
import 'package:mess_manager/core/widgets/app_components.dart';
import 'package:mess_manager/features/mess_search/providers/mess_search_provider.dart';
import 'package:mess_manager/features/mess_search/widgets/image_carousel.dart';

/// Full detail view for a mess advertisement.
class MessAdDetailScreen extends ConsumerWidget {
  final String adId;
  const MessAdDetailScreen({super.key, required this.adId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ads = ref.watch(messSearchProvider).ads;
    final ad = ads.where((a) => a.id == adId).firstOrNull;

    if (ad == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimaryDark),
        ),
        body: const Center(
          child: Text('Ad not found', style: TextStyle(color: Colors.white54)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Image gallery header
          SliverToBoxAdapter(
            child: _ImageHeader(ad: ad),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          ad.title,
                          style: AppTypography.headlineLarge.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ),
                      _StatusBadge(isActive: ad.isActive),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .slideX(begin: -0.02, end: 0, duration: 300.ms),
                  const Gap(AppSpacing.sm),

                  // Location row
                  Row(
                    children: [
                      Icon(LucideIcons.mapPin,
                          size: 15, color: AppColors.accentAlt),
                      const Gap(6),
                      Expanded(
                        child: Text(
                          ad.location,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openMap(ad.location),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusXs),
                            color: AppColors.accentAlt.withValues(alpha: 0.1),
                            border: Border.all(
                              color:
                                  AppColors.accentAlt.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.map,
                                  size: 12, color: AppColors.accentAlt),
                              const Gap(4),
                              Text(
                                'Map',
                                style: AppTypography.labelSmall.copyWith(
                                  color: AppColors.accentAlt,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 80.ms)
                      .slideX(begin: -0.02, end: 0, duration: 300.ms),
                  const Gap(AppSpacing.lg),

                  // Stats row
                  _StatsRow(ad: ad)
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 120.ms)
                      .slideY(begin: 0.03, end: 0, duration: 300.ms),
                  const Gap(AppSpacing.lg),

                  // Description section
                  _SectionLabel(label: 'About this mess'),
                  const Gap(AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration:
                        AppSpacing.glassTile(radius: AppSpacing.radiusMd),
                    child: Text(
                      ad.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                        height: 1.6,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 160.ms),
                  const Gap(AppSpacing.lg),

                  // Amenities section
                  if (ad.amenities.isNotEmpty) ...[
                    _SectionLabel(label: 'Amenities'),
                    const Gap(AppSpacing.sm),
                    _AmenitiesGrid(amenities: ad.amenities)
                        .animate()
                        .fadeIn(duration: 300.ms, delay: 200.ms),
                    const Gap(AppSpacing.lg),
                  ],

                  // Contact section
                  _SectionLabel(label: 'Contact'),
                  const Gap(AppSpacing.sm),
                  _ContactCard(ad: ad)
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 240.ms)
                      .slideY(begin: 0.03, end: 0, duration: 300.ms),

                  // Bottom padding for FAB
                  const Gap(100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Contact actions FAB bar
      bottomNavigationBar: _BottomContactBar(ad: ad),
    );
  }

  void _openMap(String location) async {
    final query = Uri.encodeComponent(location);
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}

/// Image header with carousel and back button overlay.
class _ImageHeader extends StatelessWidget {
  final MessAd ad;
  const _ImageHeader({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageCarousel(
          imageUrls: ad.imageUrls,
          height: 300,
          borderRadius: BorderRadius.zero,
          showIndicator: true,
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, _) =>
                    FullScreenGallery(imageUrls: ad.imageUrls),
                transitionsBuilder: (_, anim, __, child) =>
                    FadeTransition(opacity: anim, child: child),
              ),
            );
          },
        ),

        // Gradient overlay at top for status bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Back button
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          child: GestureDetector(
            onTap: () {
              HapticService.lightTap();
              Navigator.of(context).pop();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: const Icon(
                LucideIcons.arrowLeft,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),

        // Members badge
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.3),
                  blurRadius: 12,
                  spreadRadius: -3,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.users,
                    size: 14, color: AppColors.accent),
                const Gap(5),
                Text(
                  ad.membersNeeded == 1
                      ? '1 seat open'
                      : '${ad.membersNeeded} seats open',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Stats row showing rent, members needed, and posted date.
class _StatsRow extends StatelessWidget {
  final MessAd ad;
  const _StatsRow({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (ad.rentPerPerson != null)
          _StatTile(
            icon: LucideIcons.banknote,
            label: 'Rent/person',
            value: '৳${ad.rentPerPerson!.toInt()}',
            color: AppColors.accent,
          ),
        if (ad.rentPerPerson != null) const Gap(AppSpacing.sm),
        _StatTile(
          icon: LucideIcons.users,
          label: 'Seats open',
          value: '${ad.membersNeeded}',
          color: AppColors.accentAlt,
        ),
        const Gap(AppSpacing.sm),
        _StatTile(
          icon: LucideIcons.image,
          label: 'Photos',
          value: '${ad.imageUrls.length}',
          color: AppColors.accentWarm,
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: AppSpacing.accentCard(accent: color),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const Gap(6),
            Text(
              value,
              style: AppTypography.mono.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const Gap(2),
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: color.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Section label with accent bar.
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Gap(AppSpacing.sm),
        Text(
          label,
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryDark,
          ),
        ),
      ],
    );
  }
}

/// Grid of amenities with icons.
class _AmenitiesGrid extends StatelessWidget {
  final List<String> amenities;
  const _AmenitiesGrid({required this.amenities});

  static const _amenityIcons = {
    'WiFi': LucideIcons.wifi,
    'Gas': LucideIcons.flame,
    'Water': LucideIcons.droplets,
    'AC': LucideIcons.snowflake,
    'Security': LucideIcons.shield,
    'Lift': LucideIcons.arrowUpDown,
    'Generator': LucideIcons.zap,
    'Gym': LucideIcons.dumbbell,
    'Parking': LucideIcons.car,
    'Cook': LucideIcons.chefHat,
    'Laundry': LucideIcons.shirt,
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: amenities.map((amenity) {
        final icon = _amenityIcons[amenity] ?? LucideIcons.check;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: AppSpacing.glassTile(radius: AppSpacing.radiusSm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: AppColors.accentAlt),
              const Gap(8),
              Text(
                amenity,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Contact info card.
class _ContactCard extends StatelessWidget {
  final MessAd ad;
  const _ContactCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSpacing.glassTile(radius: AppSpacing.radiusMd),
      child: Row(
        children: [
          AppMemberAvatar(name: ad.postedByName, size: 44),
          const Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad.postedByName,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const Gap(2),
                Row(
                  children: [
                    const Icon(LucideIcons.phone,
                        size: 12, color: AppColors.textMutedDark),
                    const Gap(4),
                    Text(
                      ad.contactNumber,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Active/inactive badge.
class _StatusBadge extends StatelessWidget {
  final bool isActive;
  const _StatusBadge({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      text: isActive ? 'Active' : 'Closed',
      color: isActive ? AppColors.success : AppColors.textMutedDark,
    );
  }
}

/// Bottom contact action bar.
class _BottomContactBar extends StatelessWidget {
  final MessAd ad;
  const _BottomContactBar({required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          // Call button
          Expanded(
            child: AppSecondaryButton(
              text: 'Call',
              icon: LucideIcons.phone,
              color: AppColors.accentAlt,
              onPressed: () async {
                HapticService.buttonPress();
                final url = Uri.parse('tel:${ad.contactNumber}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          ),
          const Gap(AppSpacing.sm),
          // Message button
          Expanded(
            flex: 2,
            child: AppPrimaryButton(
              text: 'Message',
              icon: LucideIcons.messageCircle,
              onPressed: () async {
                HapticService.buttonPress();
                final url = Uri.parse('sms:${ad.contactNumber}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
