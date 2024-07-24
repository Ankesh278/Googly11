

import 'package:world11/Model/TransactionHistoryModel/MatchTransactionDetails.dart';

class MainTransactionData {
  MainTransactionData({
     required this.id,
    required this.userId,
    required this.transactionType,
    required  this.amount,
    required this.timestamp,
    required this.status,
      this.paymentStatus, 
      this.description,
    required  this.transactionCategory,
    required  this.transactionReferenceId,
    required  this.fee,
      this.currency, 
      this.source, 
      this.destination,
    required  this.userTMId,
    required  this.createdAt,
    required this.matchTransactionInfo,
    required  this.updatedAt,});

  MainTransactionData.fromJson(dynamic json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    transactionType = json['transaction_type'] ?? '';
    amount = json['amount']  ?? '';
    timestamp = json['timestamp']  ?? '';
    status = json['status']  ?? '';
    paymentStatus = json['payment_status'];
    description = json['description'];
    transactionCategory = json['transaction_category']  ?? '';
    transactionReferenceId = json['transaction_reference_id'] ?? '';
    fee = json['fee'] ?? '';
    currency = json['currency'];
    source = json['source'];
    destination = json['destination'];
    userTMId = json['user_t_m_id'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    matchTransactionInfo = json['matchInfo'] != null ? MatchTransactionInfo.fromJson(json['matchInfo']) : null;
  }
  int id = 0;
  int userId = 0;
  String transactionType = '';
  String amount = '';
  String timestamp = '';
  String status = '';
  dynamic paymentStatus;
  dynamic description;
  String transactionCategory = '';
  String transactionReferenceId = '';
  String fee = '';
  dynamic currency;
  dynamic source;
  dynamic destination;
  int userTMId = 0;
  String createdAt = '';
  String updatedAt = '';
  MatchTransactionInfo? matchTransactionInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['transaction_type'] = transactionType;
    map['amount'] = amount;
    map['timestamp'] = timestamp;
    map['status'] = status;
    map['payment_status'] = paymentStatus;
    map['description'] = description;
    map['transaction_category'] = transactionCategory;
    map['transaction_reference_id'] = transactionReferenceId;
    map['fee'] = fee;
    map['currency'] = currency;
    map['source'] = source;
    map['destination'] = destination;
    map['user_t_m_id'] = userTMId;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (matchTransactionInfo != null) {
      map['matchInfo'] = matchTransactionInfo!.toJson();
    }
    return map;
  }

}