


class MatchList {
  String? apikey;
  List<Data>? data;
  String? status;
  Info? info;

  MatchList({this.apikey, this.data, this.status, this.info});

  MatchList.fromJson(Map<String, dynamic> json) {
    apikey = json['apikey'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
    info = json['info'] != null ? new Info.fromJson(json['info']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apikey'] = this.apikey;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    if (this.info != null) {
      data['info'] = this.info!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? dateTimeGMT;
  String? matchType;
  String? status;
  String? ms;
  String? t1;
  String? t2;
  String? t1s;
  String? t2s;
  String? t1img;
  String? t2img;

  Data(
      {this.id,
        this.dateTimeGMT,
        this.matchType,
        this.status,
        this.ms,
        this.t1,
        this.t2,
        this.t1s,
        this.t2s,
        this.t1img,
        this.t2img});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTimeGMT = json['dateTimeGMT'];
    matchType = json['matchType'];
    status = json['status'];
    ms = json['ms'];
    t1 = json['t1'];
    t2 = json['t2'];
    t1s = json['t1s'];
    t2s = json['t2s'];
    t1img = json['t1img'];
    t2img = json['t2img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateTimeGMT'] = this.dateTimeGMT;
    data['matchType'] = this.matchType;
    data['status'] = this.status;
    data['ms'] = this.ms;
    data['t1'] = this.t1;
    data['t2'] = this.t2;
    data['t1s'] = this.t1s;
    data['t2s'] = this.t2s;
    data['t1img'] = this.t1img;
    data['t2img'] = this.t2img;
    return data;
  }
}

class Info {
  int? hitsToday;
  int? hitsUsed;
  int? hitsLimit;
  int? credits;
  int? server;
  double? queryTime;
  int? s;

  Info(
      {this.hitsToday,
        this.hitsUsed,
        this.hitsLimit,
        this.credits,
        this.server,
        this.queryTime,
        this.s});

  Info.fromJson(Map<String, dynamic> json) {
    hitsToday = json['hitsToday'];
    hitsUsed = json['hitsUsed'];
    hitsLimit = json['hitsLimit'];
    credits = json['credits'];
    server = json['server'];
    queryTime = json['queryTime'];
    s = json['s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hitsToday'] = this.hitsToday;
    data['hitsUsed'] = this.hitsUsed;
    data['hitsLimit'] = this.hitsLimit;
    data['credits'] = this.credits;
    data['server'] = this.server;
    data['queryTime'] = this.queryTime;
    data['s'] = this.s;
    return data;
  }
}
