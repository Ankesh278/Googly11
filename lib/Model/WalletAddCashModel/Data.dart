class AddCashModelData {
  AddCashModelData({
     required this.id,
    required this.userId,
    required this.balance,
    required  this.totalDeposits,
    required this.totalWithdrawals,
    required this.bonusBalance,
    required this.totalEarnings,
    required this.withdrawalPending,
    required this.createdAt,
    required this.updatedAt,});

  AddCashModelData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    balance = json['balance'];
    totalDeposits = json['total_deposits'];
    totalWithdrawals = json['total_withdrawals'];
    bonusBalance = json['bonus_balance'];
    totalEarnings = json['total_earnings'];
    withdrawalPending = json['withdrawal_Pending'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int id =0;
  int userId =0;
  int balance =0;
  int totalDeposits =0;
  String totalWithdrawals ='';
  String bonusBalance ='';
  String totalEarnings ='';
  String withdrawalPending ='';
  String createdAt ='';
  String updatedAt ='';

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['balance'] = balance;
    map['total_deposits'] = totalDeposits;
    map['total_withdrawals'] = totalWithdrawals;
    map['bonus_balance'] = bonusBalance;
    map['total_earnings'] = totalEarnings;
    map['withdrawal_Pending'] = withdrawalPending;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}