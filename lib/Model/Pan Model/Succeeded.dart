import 'PanDetails.dart';

class Succeeded {
  Succeeded({
     required this.panDetails,});

  Succeeded.fromJson(dynamic json) {
    panDetails = json['pan_Details'] != null ? PanDetails.fromJson(json['pan_Details']) : null;
  }
  PanDetails? panDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (panDetails != null) {
      map['pan_Details'] = panDetails!.toJson();
    }
    return map;
  }

}