class Team1Data {
  int? teamId;
  String? teamName;
  String? teamSName;
  String? imageId;

  Team1Data({this.teamId, this.teamName, this.teamSName, this.imageId});

  Team1Data.fromJson(Map<String, dynamic> json) {
    teamId = json['teamId'];
    teamName = json['teamName'];
    teamSName = json['teamSName'];
    imageId = json['imageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamId'] = this.teamId;
    data['teamName'] = this.teamName;
    data['teamSName'] = this.teamSName;
    data['imageId'] = this.imageId;
    return data;
  }
}
