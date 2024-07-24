class AccountOverviewData {
  AccountOverviewData({
      this.totalDepositAmount, 
      this.totalWithdrawalAmount, 
      this.totalDepositBonus, 
      this.totalWithdrawalBonus, 
      this.totalDepositContest, 
      this.totalWinningContest,});

  AccountOverviewData.fromJson(dynamic json) {
    totalDepositAmount = json['total_deposit_amount'] ?? '';
    totalWithdrawalAmount = json['total_withdrawal_amount'] ?? '';
    totalDepositBonus = json['total_deposit_bonus'] ?? '';
    totalWithdrawalBonus = json['total_withdrawal_bonus'] ?? '';
    totalDepositContest = json['total_deposit_contest'] ?? '';
    totalWinningContest = json['total_winning_contest'] ?? '';
  }
  String? totalDepositAmount;
  String? totalWithdrawalAmount;
  String? totalDepositBonus;
  String? totalWithdrawalBonus;
  String? totalDepositContest;
  String? totalWinningContest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total_deposit_amount'] = totalDepositAmount;
    map['total_withdrawal_amount'] = totalWithdrawalAmount;
    map['total_deposit_bonus'] = totalDepositBonus;
    map['total_withdrawal_bonus'] = totalWithdrawalBonus;
    map['total_deposit_contest'] = totalDepositContest;
    map['total_winning_contest'] = totalWinningContest;
    return map;
  }

}