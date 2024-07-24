class VenueFieldDetails {
  final int id;
  final int venueId;
  final String ground;
  final String city;

  VenueFieldDetails({
    required this.id,
    required this.venueId,
    required this.ground,
    required this.city,
  });

  factory VenueFieldDetails.fromJson(Map<String, dynamic> json) {
    return VenueFieldDetails(
      id: json['id'] as int,
      venueId: json['venue_id'] as int,
      ground: json['ground'] as String,
      city: json['city'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venue_id': venueId,
      'ground': ground,
      'city': city,
    };
  }
}
