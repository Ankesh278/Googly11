class NewImageData {
  NewImageData({
     required this.status,
    required this.data,});

  NewImageData.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    data = json['data'] ?? '';
  }
  int status=0;
  String data ='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['data'] = data;
    return map;
  }

}