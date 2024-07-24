class PartnerShip {
  dynamic balls;
  dynamic runs;

  PartnerShip({this.balls, this.runs});

  PartnerShip.fromJson(Map<String, dynamic> json) {
    balls = json['balls']?.toInt();
    runs = json['runs']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balls'] = this.balls;
    data['runs'] = this.runs;
    return data;
  }
}
