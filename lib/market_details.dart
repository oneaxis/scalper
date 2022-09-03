class MarketDetails {
  Instrument? instrument;
  DealingRules? dealingRules;
  Snapshot? snapshot;

  MarketDetails({this.instrument, this.dealingRules, this.snapshot});

  MarketDetails.fromJson(Map<String, dynamic> json) {
    instrument = json['instrument'] != null
        ? Instrument.fromJson(json['instrument'])
        : null;
    dealingRules = json['dealingRules'] != null
        ? DealingRules.fromJson(json['dealingRules'])
        : null;
    snapshot =
        json['snapshot'] != null ? Snapshot.fromJson(json['snapshot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (instrument != null) {
      data['instrument'] = instrument!.toJson();
    }
    if (dealingRules != null) {
      data['dealingRules'] = dealingRules!.toJson();
    }
    if (snapshot != null) {
      data['snapshot'] = snapshot!.toJson();
    }
    return data;
  }
}

class Instrument {
  String? epic;
  String? expiry;
  String? name;
  int? lotSize;
  String? type;
  bool? guaranteedStopAllowed;
  bool? streamingPricesAvailable;
  String? currency;
  int? marginFactor;
  String? marginFactorUnit;
  String? openingHours;
  String? country;

  Instrument(
      {this.epic,
      this.expiry,
      this.name,
      this.lotSize,
      this.type,
      this.guaranteedStopAllowed,
      this.streamingPricesAvailable,
      this.currency,
      this.marginFactor,
      this.marginFactorUnit,
      this.openingHours,
      this.country});

  Instrument.fromJson(Map<String, dynamic> json) {
    epic = json['epic'];
    expiry = json['expiry'];
    name = json['name'];
    lotSize = json['lotSize'];
    type = json['type'];
    guaranteedStopAllowed = json['guaranteedStopAllowed'];
    streamingPricesAvailable = json['streamingPricesAvailable'];
    currency = json['currency'];
    marginFactor = json['marginFactor'];
    marginFactorUnit = json['marginFactorUnit'];
    openingHours = json['openingHours'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['epic'] = epic;
    data['expiry'] = expiry;
    data['name'] = name;
    data['lotSize'] = lotSize;
    data['type'] = type;
    data['guaranteedStopAllowed'] = guaranteedStopAllowed;
    data['streamingPricesAvailable'] = streamingPricesAvailable;
    data['currency'] = currency;
    data['marginFactor'] = marginFactor;
    data['marginFactorUnit'] = marginFactorUnit;
    data['openingHours'] = openingHours;
    data['country'] = country;
    return data;
  }
}

class DealingRules {
  MinStepDistance? minStepDistance;
  MinStepDistance? minDealSize;
  MinStepDistance? minGuaranteedStopDistance;
  MinStepDistance? minStopOrProfitDistance;
  MaxStopOrProfitDistance? maxStopOrProfitDistance;
  String? marketOrderPreference;
  String? trailingStopsPreference;

  DealingRules(
      {this.minStepDistance,
      this.minDealSize,
      this.minGuaranteedStopDistance,
      this.minStopOrProfitDistance,
      this.maxStopOrProfitDistance,
      this.marketOrderPreference,
      this.trailingStopsPreference});

  DealingRules.fromJson(Map<String, dynamic> json) {
    minStepDistance = json['minStepDistance'] != null
        ? MinStepDistance.fromJson(json['minStepDistance'])
        : null;
    minDealSize = json['minDealSize'] != null
        ? MinStepDistance.fromJson(json['minDealSize'])
        : null;
    minGuaranteedStopDistance = json['minGuaranteedStopDistance'] != null
        ? MinStepDistance.fromJson(json['minGuaranteedStopDistance'])
        : null;
    minStopOrProfitDistance = json['minStopOrProfitDistance'] != null
        ? MinStepDistance.fromJson(json['minStopOrProfitDistance'])
        : null;
    maxStopOrProfitDistance = json['maxStopOrProfitDistance'] != null
        ? MaxStopOrProfitDistance.fromJson(json['maxStopOrProfitDistance'])
        : null;
    marketOrderPreference = json['marketOrderPreference'];
    trailingStopsPreference = json['trailingStopsPreference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (minStepDistance != null) {
      data['minStepDistance'] = minStepDistance!.toJson();
    }
    if (minDealSize != null) {
      data['minDealSize'] = minDealSize!.toJson();
    }
    if (minGuaranteedStopDistance != null) {
      data['minGuaranteedStopDistance'] = minGuaranteedStopDistance!.toJson();
    }
    if (minStopOrProfitDistance != null) {
      data['minStopOrProfitDistance'] = minStopOrProfitDistance!.toJson();
    }
    if (maxStopOrProfitDistance != null) {
      data['maxStopOrProfitDistance'] = maxStopOrProfitDistance!.toJson();
    }
    data['marketOrderPreference'] = marketOrderPreference;
    data['trailingStopsPreference'] = trailingStopsPreference;
    return data;
  }
}

class MinStepDistance {
  String? unit;
  double? value;

  MinStepDistance({this.unit, this.value});

  MinStepDistance.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    value = json['value'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit'] = unit;
    data['value'] = value;
    return data;
  }
}

class MaxStopOrProfitDistance {
  String? unit;
  double? value;

  MaxStopOrProfitDistance({this.unit, this.value});

  MaxStopOrProfitDistance.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    value = json['value'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit'] = unit;
    data['value'] = value;
    return data;
  }
}

class Snapshot {
  String? marketStatus;
  String? updateTime;
  double? delayTime;
  double? bid;
  double? offer;
  int? decimalPlacesFactor;
  int? scalingFactor;

  Snapshot(
      {this.marketStatus,
      this.updateTime,
      this.delayTime,
      this.bid,
      this.offer,
      this.decimalPlacesFactor,
      this.scalingFactor});

  Snapshot.fromJson(Map<String, dynamic> json) {
    marketStatus = json['marketStatus'];
    updateTime = json['updateTime'];
    delayTime = json['delayTime'].toDouble();
    bid = json['bid'];
    offer = json['offer'];
    decimalPlacesFactor = json['decimalPlacesFactor'];
    scalingFactor = json['scalingFactor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['marketStatus'] = marketStatus;
    data['updateTime'] = updateTime;
    data['delayTime'] = delayTime;
    data['bid'] = bid;
    data['offer'] = offer;
    data['decimalPlacesFactor'] = decimalPlacesFactor;
    data['scalingFactor'] = scalingFactor;
    return data;
  }
}
