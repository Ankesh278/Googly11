import '../Lanback_Url_Data/InningsScoreList.dart';

class MatchScoreDetails {
  MatchScoreDetails({
   required this.inningsScoreList,
    required this.customStatus
  });

  MatchScoreDetails.fromJson(dynamic json) {
    if (json['inningsScoreList'] != null) {
      inningsScoreList = [];
      json['inningsScoreList'].forEach((v) {
        inningsScoreList!.add(InningsScoreList.fromJson(v));
      });
    };
    customStatus = json['customStatus'] ?? '';
  }
  List<InningsScoreList>? inningsScoreList;
  String customStatus='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (inningsScoreList != null) {
      map['inningsScoreList'] = inningsScoreList!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}