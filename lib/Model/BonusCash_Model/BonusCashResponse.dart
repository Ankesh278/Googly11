class BonusCashResponse {
  BonusCashResponse({
      this.status, 
      this.currentBonusAmount, 
      this.totalDeposits, 
      this.totalWithdrawals,});

  BonusCashResponse.fromJson(dynamic json) {
    status = json['status'] ?? 0;
    currentBonusAmount = json['current_bonus_amount'] ?? '';
    totalDeposits = json['total_deposits'] ?? 0;
    totalWithdrawals = json['total_withdrawals'] ?? 0;
  }
  int? status;
  String? currentBonusAmount;
  int? totalDeposits;
  int? totalWithdrawals;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['current_bonus_amount'] = currentBonusAmount;
    map['total_deposits'] = totalDeposits;
    map['total_withdrawals'] = totalWithdrawals;
    return map;
  }

}