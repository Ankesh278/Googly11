class InngsData {
  dynamic inningsId;
  dynamic runs;
  dynamic wickets;
  dynamic overs;

  InngsData({this.inningsId, this.runs, this.wickets, this.overs});

  InngsData.fromJson(Map<String, dynamic> json) {
    inningsId = json['inningsId'];
    runs = json['runs'];
    wickets = json['wickets'];
    overs = json['overs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inningsId'] = this.inningsId;
    data['runs'] = this.runs;
    data['wickets'] = this.wickets;
    data['overs'] = this.overs;
    return data;
  }
}