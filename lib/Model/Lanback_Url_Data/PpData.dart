import 'Pp1.dart';

class PpData {
  PpData({
    required this.pp1,});

  PpData.fromJson(dynamic json) {
    pp1 = json['pp_1'] != null ? Pp1.fromJson(json['pp_1']) : null;
  }
  Pp1? pp1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pp1 != null) {
      map['pp_1'] = pp1!.toJson();
    }
    return map;
  }

}