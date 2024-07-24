import 'Data.dart';
class WallelModelData {
  WallelModelData({
    required  this.status,
    required this.data,});

  WallelModelData.fromJson(dynamic json) {
    status = json['status'];
    data = json['data'] != null ? WalletResponseData.fromJson(json['data']) : null;
  }
  int status = 0;
  WalletResponseData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}