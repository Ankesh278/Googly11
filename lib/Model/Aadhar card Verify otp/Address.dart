class Address {
  Address({
      required this.country,
    required this.dist,
    required  this.state,
    required  this.po,
    required this.loc,
    required this.vtc,
    required  this.subdist,
    required  this.street,
    required  this.house,
    required this.landmark,});

  Address.fromJson(dynamic json) {
    country = json['country'];
    dist = json['dist'];
    state = json['state'];
    po = json['po'];
    loc = json['loc'];
    vtc = json['vtc'];
    subdist = json['subdist'];
    street = json['street'];
    house = json['house'];
    landmark = json['landmark'];
  }
  String country="";
  String dist="";
  String state="";
  String po="";
  String loc="";
  String vtc="";
  String subdist="";
  String street="";
  String house="";
  String landmark="";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = country;
    map['dist'] = dist;
    map['state'] = state;
    map['po'] = po;
    map['loc'] = loc;
    map['vtc'] = vtc;
    map['subdist'] = subdist;
    map['street'] = street;
    map['house'] = house;
    map['landmark'] = landmark;
    return map;
  }

}