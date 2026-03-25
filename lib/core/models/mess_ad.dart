/// A mess advertisement posted by messes looking for new members.
class MessAd {
  final String id;
  final String title;
  final String description;
  final String location;
  final String contactNumber;
  final int membersNeeded;
  final double? rentPerPerson;
  final List<String> imageUrls;
  final String postedBy;
  final String postedByName;
  final DateTime createdAt;
  final List<String> amenities;
  final bool isActive;

  const MessAd({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.contactNumber,
    required this.membersNeeded,
    this.rentPerPerson,
    required this.imageUrls,
    required this.postedBy,
    required this.postedByName,
    required this.createdAt,
    this.amenities = const [],
    this.isActive = true,
  });

  MessAd copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    String? contactNumber,
    int? membersNeeded,
    double? rentPerPerson,
    List<String>? imageUrls,
    String? postedBy,
    String? postedByName,
    DateTime? createdAt,
    List<String>? amenities,
    bool? isActive,
  }) {
    return MessAd(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      contactNumber: contactNumber ?? this.contactNumber,
      membersNeeded: membersNeeded ?? this.membersNeeded,
      rentPerPerson: rentPerPerson ?? this.rentPerPerson,
      imageUrls: imageUrls ?? this.imageUrls,
      postedBy: postedBy ?? this.postedBy,
      postedByName: postedByName ?? this.postedByName,
      createdAt: createdAt ?? this.createdAt,
      amenities: amenities ?? this.amenities,
      isActive: isActive ?? this.isActive,
    );
  }

  factory MessAd.fromJson(Map<String, dynamic> json) {
    return MessAd(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      contactNumber: json['contactNumber'] as String,
      membersNeeded: json['membersNeeded'] as int,
      rentPerPerson: (json['rentPerPerson'] as num?)?.toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      postedBy: json['postedBy'] as String,
      postedByName: json['postedByName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'contactNumber': contactNumber,
      'membersNeeded': membersNeeded,
      'rentPerPerson': rentPerPerson,
      'imageUrls': imageUrls,
      'postedBy': postedBy,
      'postedByName': postedByName,
      'createdAt': createdAt.toIso8601String(),
      'amenities': amenities,
      'isActive': isActive,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessAd &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'MessAd(id: $id, title: $title, members: $membersNeeded)';
}
