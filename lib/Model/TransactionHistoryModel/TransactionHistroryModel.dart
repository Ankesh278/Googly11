import 'TransactionData.dart';

class TransactionHistroryModel {
  TransactionHistroryModel({
     required this.status,
    required this.transactionData,});

  TransactionHistroryModel.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    transactionData = json['transaction_data'] != null ? TransactionData.fromJson(json['transaction_data']) : null;
  }
  int status = 0;
  TransactionData? transactionData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (transactionData != null) {
      map['transaction_data'] = transactionData!.toJson();
    }
    return map;
  }

}