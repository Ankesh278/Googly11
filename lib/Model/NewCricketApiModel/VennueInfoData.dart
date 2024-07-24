class VenueInfoData {
  int? id;
  String? ground;
  String? city;
  String? timezone;
  String? latitude;
  String? longitude;

  VenueInfoData(
      {this.id,
        this.ground,
        this.city,
        this.timezone,
        this.latitude,
        this.longitude});

  VenueInfoData.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    ground = json['ground'] ?? '';
    city = json['city'] ?? '';
    timezone = json['timezone'] ?? '';
    latitude = json['latitude'] ?? '';
    longitude = json['longitude'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ground'] = this.ground;
    data['city'] = this.city;
    data['timezone'] = this.timezone;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}