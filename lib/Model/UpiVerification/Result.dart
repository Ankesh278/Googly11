import 'UpiDetailsList.dart';

class Result {
  Result({
      this.upiDetailsList,});

  Result.fromJson(dynamic json) {
    if (json['upiDetailsList'] != null) {
      upiDetailsList = [];
      json['upiDetailsList'].forEach((v) {
        upiDetailsList!.add(UpiDetailsList.fromJson(v));
      });
    }
  }
  List<UpiDetailsList>? upiDetailsList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (upiDetailsList != null) {
      map['upiDetailsList'] = upiDetailsList!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}