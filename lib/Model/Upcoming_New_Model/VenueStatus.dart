class VenueStatus {
  List<VenueStat>? venueStats;
  VenueStatus({required this.venueStats});

   VenueStatus.fromJson(Map<String, dynamic> json) {
     if (json['venueStats'] != null) {
       venueStats = [];
       json['venueStats'].forEach((v) {
         venueStats!.add(VenueStat.fromJson(v));
       });
     }
  }
}

class VenueStat {
  String key;
  String value;

  VenueStat({required this.key, required this.value});

  factory VenueStat.fromJson(Map<String, dynamic> json) {
    return VenueStat(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
    );
  }
}
