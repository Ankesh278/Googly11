class BowlerStriker {
  BowlerStriker({
    required  this.bowlId,
    required  this.bowlName,
    required  this.bowlOvs,
    required  this.bowlRuns,
    required  this.bowlWides,
    required   this.bowlWkts,});

  BowlerStriker.fromJson(dynamic json) {
    bowlId = json['bowlId'] ?? 0;
    bowlName = json['bowlName'] ?? '';
    bowlOvs = json['bowlOvs'] ?? 0.0;
    bowlRuns = json['bowlRuns'] ?? 0;
    bowlWides = json['bowlWides'] ?? 0;
    bowlWkts = json['bowlWkts'] ?? 0;
  }
  dynamic bowlId = 0;
  dynamic bowlName = '';
  dynamic bowlOvs = 0.0;
  dynamic bowlRuns = 0;
  dynamic bowlWides = 0;
  dynamic bowlWkts =0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bowlId'] = bowlId;
    map['bowlName'] = bowlName;
    map['bowlOvs'] = bowlOvs;
    map['bowlRuns'] = bowlRuns;
    map['bowlWides'] = bowlWides;
    map['bowlWkts'] = bowlWkts;
    return map;
  }

}