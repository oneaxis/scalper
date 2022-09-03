class Account {
  String accountId;
  String accountName;
  bool preferred;
  String accountType;

  Account(
      {required this.accountId,
      required this.accountName,
      required this.preferred,
      required this.accountType});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'],
      accountName: json['accountName'],
      preferred: json['preferred'],
      accountType: json['accountType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountId'] = accountId;
    data['accountName'] = accountName;
    data['preferred'] = preferred;
    data['accountType'] = accountType;
    return data;
  }
}
