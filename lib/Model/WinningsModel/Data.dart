import 'PrizeDistributions.dart';

class Data {
  Data({

    required   this.prizeDistributions,});

  Data.fromJson(dynamic json) {

    if (json['prize_distributions'] != null) {
      prizeDistributions = [];
      json['prize_distributions'].forEach((v) {
        prizeDistributions!.add(PrizeDistributions.fromJson(v));
      });
    }
  }

  List<PrizeDistributions>? prizeDistributions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (prizeDistributions != null) {
      map['prize_distributions'] = prizeDistributions!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}