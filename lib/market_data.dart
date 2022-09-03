class MarketData {
  final String status;
  final String destination;
  final Payload payload;

  MarketData(
      {required this.status, required this.destination, required this.payload});

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      status: json['status'],
      destination: json['destination'],
      payload: Payload.fromJson(json['payload']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['destination'] = destination;
    data['payload'] = payload.toJson();
    return data;
  }
}

class Payload {
  final String epic;
  final String product;
  final double bid;
  final double bidQty;
  final double ofr;
  final double ofrQty;
  final int timestamp;

  Payload(
      {required this.epic,
      required this.product,
      required this.bid,
      required this.bidQty,
      required this.ofr,
      required this.ofrQty,
      required this.timestamp});

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      epic: json['epic'],
      product: json['product'],
      bid: json['bid'],
      bidQty: json['bidQty'].toDouble(),
      ofr: json['ofr'],
      ofrQty: json['ofrQty'].toDouble(),
      timestamp: json['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['epic'] = epic;
    data['product'] = product;
    data['bid'] = bid;
    data['bidQty'] = bidQty;
    data['ofr'] = ofr;
    data['ofrQty'] = ofrQty;
    data['timestamp'] = timestamp;
    return data;
  }
}
