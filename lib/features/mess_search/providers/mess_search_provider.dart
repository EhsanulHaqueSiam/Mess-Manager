import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mess_manager/core/models/mess_ad.dart';

/// Filter options for mess search
enum MessSearchFilter { all, oneMember, twoMembers, threeOrMore }

/// State for the mess search feature
class MessSearchState {
  final List<MessAd> ads;
  final String query;
  final MessSearchFilter filter;
  final bool isLoading;

  const MessSearchState({
    this.ads = const [],
    this.query = '',
    this.filter = MessSearchFilter.all,
    this.isLoading = false,
  });

  MessSearchState copyWith({
    List<MessAd>? ads,
    String? query,
    MessSearchFilter? filter,
    bool? isLoading,
  }) {
    return MessSearchState(
      ads: ads ?? this.ads,
      query: query ?? this.query,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier for mess search ads
class MessSearchNotifier extends Notifier<MessSearchState> {
  @override
  MessSearchState build() {
    return MessSearchState(ads: _generateSampleAds());
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  void setFilter(MessSearchFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void addAd(MessAd ad) {
    state = state.copyWith(ads: [ad, ...state.ads]);
  }

  void removeAd(String id) {
    state = state.copyWith(
      ads: state.ads.where((a) => a.id != id).toList(),
    );
  }

  List<MessAd> _generateSampleAds() {
    final now = DateTime.now();
    return [
      MessAd(
        id: 'ad_1',
        title: 'Sunny Corner Mess',
        description:
            'Spacious room available with attached balcony. Clean kitchen, '
            'filtered water, and 24/7 security. Perfect for students or working '
            'professionals. Common area with TV and high-speed WiFi.',
        location: 'Mirpur-10, Dhaka',
        contactNumber: '+880 1712-345678',
        membersNeeded: 2,
        rentPerPerson: 5500,
        imageUrls: [
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
          'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        ],
        postedBy: 'user_1',
        postedByName: 'Rafiq Ahmed',
        createdAt: now.subtract(const Duration(hours: 3)),
        amenities: ['WiFi', 'Gas', 'Water', 'Security'],
      ),
      MessAd(
        id: 'ad_2',
        title: 'Green View Mess',
        description:
            'Newly renovated building with modern amenities. Rooftop space, '
            'generator backup, and lift access. Walking distance to market and '
            'bus stop. Home-cooked meals available.',
        location: 'Uttara Sector-7, Dhaka',
        contactNumber: '+880 1812-456789',
        membersNeeded: 1,
        rentPerPerson: 7000,
        imageUrls: [
          'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?w=800',
          'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        ],
        postedBy: 'user_2',
        postedByName: 'Karim Hassan',
        createdAt: now.subtract(const Duration(hours: 8)),
        amenities: ['WiFi', 'Gas', 'Lift', 'Generator'],
      ),
      MessAd(
        id: 'ad_3',
        title: 'City Life Mess',
        description:
            'Located in the heart of Dhanmondi. Furnished rooms with AC option. '
            'Close to universities and offices. Meal system with dedicated cook. '
            'Laundry service available.',
        location: 'Dhanmondi-27, Dhaka',
        contactNumber: '+880 1912-567890',
        membersNeeded: 3,
        rentPerPerson: 6000,
        imageUrls: [
          'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
          'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800',
          'https://images.unsplash.com/photo-1630699144867-37acec97df5a?w=800',
          'https://images.unsplash.com/photo-1513694203232-719a280e022f?w=800',
        ],
        postedBy: 'user_3',
        postedByName: 'Tanvir Islam',
        createdAt: now.subtract(const Duration(days: 1)),
        amenities: ['WiFi', 'AC', 'Cook', 'Laundry'],
      ),
      MessAd(
        id: 'ad_4',
        title: 'Budget Friendly Mess',
        description:
            'Affordable shared living in Mohammadpur. Two seats available in '
            'a triple-sharing room. Common bathroom and kitchen. Ideal for '
            'students on a budget.',
        location: 'Mohammadpur, Dhaka',
        contactNumber: '+880 1612-678901',
        membersNeeded: 2,
        rentPerPerson: 3500,
        imageUrls: [
          'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?w=800',
          'https://images.unsplash.com/photo-1564078516393-cf04bd966897?w=800',
        ],
        postedBy: 'user_4',
        postedByName: 'Shakil Mahmud',
        createdAt: now.subtract(const Duration(days: 2)),
        amenities: ['Gas', 'Water'],
      ),
      MessAd(
        id: 'ad_5',
        title: 'Premium Residence Mess',
        description:
            'Executive mess with private rooms, en-suite bathrooms, and '
            'premium furnishing. Gym access in the building. Dedicated parking. '
            'Meal plan with variety menu. Best for professionals.',
        location: 'Gulshan-2, Dhaka',
        contactNumber: '+880 1512-789012',
        membersNeeded: 1,
        rentPerPerson: 12000,
        imageUrls: [
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
          'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
          'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=800',
        ],
        postedBy: 'user_5',
        postedByName: 'Nabil Rahman',
        createdAt: now.subtract(const Duration(days: 3)),
        amenities: ['WiFi', 'AC', 'Gym', 'Parking', 'Cook', 'Generator'],
      ),
    ];
  }
}

final messSearchProvider =
    NotifierProvider<MessSearchNotifier, MessSearchState>(
  MessSearchNotifier.new,
);

/// Filtered ads based on current query and filter
final filteredMessAdsProvider = Provider<List<MessAd>>((ref) {
  final state = ref.watch(messSearchProvider);
  var ads = state.ads.where((a) => a.isActive).toList();

  // Apply filter
  switch (state.filter) {
    case MessSearchFilter.oneMember:
      ads = ads.where((a) => a.membersNeeded == 1).toList();
    case MessSearchFilter.twoMembers:
      ads = ads.where((a) => a.membersNeeded == 2).toList();
    case MessSearchFilter.threeOrMore:
      ads = ads.where((a) => a.membersNeeded >= 3).toList();
    case MessSearchFilter.all:
      break;
  }

  // Apply search query
  if (state.query.isNotEmpty) {
    final q = state.query.toLowerCase();
    ads = ads.where((a) {
      return a.title.toLowerCase().contains(q) ||
          a.location.toLowerCase().contains(q) ||
          a.description.toLowerCase().contains(q);
    }).toList();
  }

  // Sort by date (newest first)
  ads.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return ads;
});
