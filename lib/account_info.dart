class AccountInfo {
  final double balance;
  final double deposit;
  final double profitLoss;
  final double available;

  AccountInfo(
      {required this.balance,
      required this.deposit,
      required this.profitLoss,
      required this.available});

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
        balance: json['balance'],
        deposit: json['deposit'],
        profitLoss: json['profitLoss'],
        available: json['available']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['deposit'] = deposit;
    data['profitLoss'] = profitLoss;
    data['available'] = available;
    return data;
  }
}
