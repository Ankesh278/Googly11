import 'Data.dart';

class WalletAddCashModel {
  WalletAddCashModel({
     required this.status,
    required this.data,});

  WalletAddCashModel.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    data = json['data'] != null ? AddCashModelData.fromJson(json['data']) : null;
  }
  int status=0;
  AddCashModelData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

}