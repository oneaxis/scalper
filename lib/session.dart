import 'account.dart';
import 'account_info.dart';

class Session {
  final String accountType;
  final AccountInfo accountInfo;
  final String currencyIsoCode;
  final String currencySymbol;
  final String currentAccountId;
  final String streamingHost;
  final List<Account> accounts;
  final String clientId;
  final int timezoneOffset;
  final bool hasActiveDemoAccounts;
  final bool hasActiveLiveAccounts;
  final bool trailingStopsEnabled;
  final String securityToken;
  final String cst;

  Session(
      {required this.accountType,
      required this.accountInfo,
      required this.currencyIsoCode,
      required this.currencySymbol,
      required this.currentAccountId,
      required this.streamingHost,
      required this.accounts,
      required this.clientId,
      required this.timezoneOffset,
      required this.hasActiveDemoAccounts,
      required this.hasActiveLiveAccounts,
      required this.trailingStopsEnabled,
      required this.securityToken,
      required this.cst});

  factory Session.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> headers) {
    final List<Account> accounts = <Account>[];
    json['accounts'].forEach((v) {
      accounts.add(Account.fromJson(v));
    });

    final String securityToken = headers['x-security-token'];
    final String cst = headers['cst'];

    return Session(
      accounts: accounts,
      accountType: json['accountType'],
      accountInfo: AccountInfo.fromJson(json['accountInfo']),
      currencyIsoCode: json['currencyIsoCode'],
      currencySymbol: json['currencySymbol'],
      currentAccountId: json['currentAccountId'],
      streamingHost: json['streamingHost'],
      clientId: json['clientId'],
      timezoneOffset: json['timezoneOffset'],
      hasActiveDemoAccounts: json['hasActiveDemoAccounts'],
      hasActiveLiveAccounts: json['hasActiveLiveAccounts'],
      trailingStopsEnabled: json['trailingStopsEnabled'],
      securityToken: securityToken,
      cst: cst,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountType'] = accountType;
    data['accountInfo'] = accountInfo.toJson();
    data['currencyIsoCode'] = currencyIsoCode;
    data['currencySymbol'] = currencySymbol;
    data['currentAccountId'] = currentAccountId;
    data['streamingHost'] = streamingHost;
    data['accounts'] = accounts.map((v) => v.toJson()).toList();
    data['clientId'] = clientId;
    data['timezoneOffset'] = timezoneOffset;
    data['hasActiveDemoAccounts'] = hasActiveDemoAccounts;
    data['hasActiveLiveAccounts'] = hasActiveLiveAccounts;
    data['trailingStopsEnabled'] = trailingStopsEnabled;
    return data;
  }
}
