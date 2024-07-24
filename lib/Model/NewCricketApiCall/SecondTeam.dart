class SecondTeam {
  SecondTeam({
    required this.teamId,
    required this.teamName,
    required this.teamSName,
    required this.imageId,
    required this.imageData
  });

  SecondTeam.fromJson(dynamic json) {
    teamId = json['teamId'] ?? 0;
    teamName = json['teamName'] ?? '';
    teamSName = json['teamSName'] ?? '';
    imageId = json['imageId'] ?? 0;
    imageData =json['imageData'] ?? '';
  }
  int teamId =0;
  String teamName ='';
  String teamSName ='';
  int imageId =0;
  String imageData= '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['teamId'] = teamId;
    map['teamName'] = teamName;
    map['teamSName'] = teamSName;
    map['imageId'] = imageId;
    map['imageData'] = imageData;
    return map;
  }

}