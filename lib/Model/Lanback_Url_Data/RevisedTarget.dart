class RevisedTarget {
  RevisedTarget({
     required this.reason,});

  RevisedTarget.fromJson(dynamic json) {
    reason = json['reason'] ?? '';
  }
  String reason = '';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['reason'] = reason;
    return map;
  }

}