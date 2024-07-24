class BowlerNonStriker {
  dynamic bowlId;
  String? bowlName;
  dynamic bowlMaidens;
  dynamic bowlNoballs;
  dynamic bowlOvs;
  dynamic bowlRuns;
  dynamic bowlWides;
  dynamic bowlWkts;
  dynamic bowlEcon;

  BowlerNonStriker({
    this.bowlId,
    this.bowlName,
    this.bowlMaidens,
    this.bowlNoballs,
    this.bowlOvs,
    this.bowlRuns,
    this.bowlWides,
    this.bowlWkts,
    this.bowlEcon,
  });

  BowlerNonStriker.fromJson(Map<String, dynamic> json) {
    bowlId = json['bowlId']?.toInt();
    bowlName = json['bowlName'] ?? '';
    bowlMaidens = json['bowlMaidens']?.toInt();
    bowlNoballs = json['bowlNoballs']?.toInt();
    bowlOvs = json['bowlOvs']?.toInt();
    bowlRuns = json['bowlRuns']?.toInt();
    bowlWides = json['bowlWides']?.toInt();
    bowlWkts = json['bowlWkts']?.toInt();
    bowlEcon = json['bowlEcon'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bowlId'] = this.bowlId;
    data['bowlName'] = this.bowlName;
    data['bowlMaidens'] = this.bowlMaidens;
    data['bowlNoballs'] = this.bowlNoballs;
    data['bowlOvs'] = this.bowlOvs;
    data['bowlRuns'] = this.bowlRuns;
    data['bowlWides'] = this.bowlWides;
    data['bowlWkts'] = this.bowlWkts;
    data['bowlEcon'] = this.bowlEcon;
    return data;
  }
}
