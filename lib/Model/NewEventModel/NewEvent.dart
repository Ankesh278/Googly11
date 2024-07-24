import 'Result.dart';

class NewEvent {
  NewEvent({
      required this.success,
      required this.result,});

  NewEvent.fromJson(dynamic json) {
    success = json['success'];
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result!.add(Results.fromJson(v));
      });
    }
  }
  int success=0;
  List<Results>? result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (result != null) {
      map['result'] = result!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}