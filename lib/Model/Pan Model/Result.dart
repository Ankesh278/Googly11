import 'Succeeded.dart';

class Result {
  Result({
    required  this.succeeded,});

  Result.fromJson(dynamic json) {
    succeeded = json['Succeeded'] != null ? Succeeded.fromJson(json['Succeeded']) : null;
  }
  Succeeded? succeeded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (succeeded != null) {
      map['Succeeded'] = succeeded!.toJson();
    }
    return map;
  }

}