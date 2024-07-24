class BankVerification {
  late final int referenceId;
  late final String nameAtBank;
  late final String bankName;
  String? utr;
  late final String city;
  late final String branch;
  int? micr;
  double? nameMatchScore;
  String? nameMatchResult;
  late final String accountStatus;
  late final String accountStatusCode;

  BankVerification({
    required this.referenceId,
    required this.nameAtBank,
    required this.bankName,
    this.utr,
    required this.city,
    required this.branch,
    this.micr,
    this.nameMatchScore,
    this.nameMatchResult,
    required this.accountStatus,
    required this.accountStatusCode,
  });

  factory BankVerification.fromJson(Map<String, dynamic> json) {
    return BankVerification(
      referenceId: json['reference_id'] ?? 0,
      nameAtBank: json['name_at_bank'] ?? '',
      bankName: json['bank_name'] ?? '',
      utr: json['utr'],
      city: json['city'] ?? '',
      branch: json['branch'] ?? '',
      micr: json['micr'],
      nameMatchScore: json['name_match_score'] != null ? (json['name_match_score'] as num).toDouble() : null,
      nameMatchResult: json['name_match_result'],
      accountStatus: json['account_status'] ?? '',
      accountStatusCode: json['account_status_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['reference_id'] = referenceId;
    data['name_at_bank'] = nameAtBank;
    data['bank_name'] = bankName;
    data['utr'] = utr;
    data['city'] = city;
    data['branch'] = branch;
    data['micr'] = micr;
    data['name_match_score'] = nameMatchScore;
    data['name_match_result'] = nameMatchResult;
    data['account_status'] = accountStatus;
    data['account_status_code'] = accountStatusCode;
    return data;
  }
}
