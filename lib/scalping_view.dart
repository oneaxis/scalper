import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scalper/market_data.dart';
import 'package:scalper/market_details.dart';
import 'package:scalper/session.dart';
import 'package:web_socket_channel/io.dart';

class ScalpingView extends StatefulWidget {
  const ScalpingView({super.key, required this.session});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  final Session session;

  @override
  State<ScalpingView> createState() => _ScalpingViewState();
}

class _ScalpingViewState extends State<ScalpingView> {
  final _epicFormKey = GlobalKey<FormState>();
  final _epicController = TextEditingController();
  MarketData? _currentMarketData, _lastMarketData;

  MarketDetails? _currentMarketDetails, _lastMarketDetails;
  final _webSocketChannel = IOWebSocketChannel.connect(
      "wss://api-streaming-capital.backend-capital.com/connect");

  @override
  void initState() {
    _epicController.text = 'BTCUSD'; // TODO: remove
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _webSocketChannel.sink.close();
    _epicController.dispose();
    super.dispose();
  }

  _updateEpic(epicName) {
    _webSocketChannel.sink.add(
      jsonEncode({
        "destination": "marketData.unsubscribe",
        "correlationId": "1",
        "cst": widget.session.cst,
        "securityToken": widget.session.securityToken,
        "payload": {
          "epics": [_lastMarketData?.payload.epic]
        }
      }),
    );

    _lastMarketData = null;
    _lastMarketDetails = null;
    _currentMarketData = null;
    _currentMarketDetails = null;

    _webSocketChannel.sink.add(
      jsonEncode({
        "destination": "marketData.subscribe",
        "correlationId": "1",
        "cst": widget.session.cst,
        "securityToken": widget.session.securityToken,
        "payload": {
          "epics": [epicName]
        }
      }),
    );

    http
        .get(
          Uri.parse(
              'https://demo-api-capital.backend-capital.com/api/v1/markets/$epicName'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-SECURITY-TOKEN': widget.session.securityToken,
            'CST': widget.session.cst
          },
        )
        .then((data) => {_onGetMarketDetailsSuccess(data, context)})
        .catchError((error) => {_onGetMarketDetailsError(error, context)});
  }

  _onGetMarketDetailsSuccess(http.Response data, BuildContext context) {
    setState(() {
      _currentMarketDetails = MarketDetails.fromJson(jsonDecode(data.body));
    });
  }

  _onGetMarketDetailsError(dynamic error, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }

  double _getCurrentSellPrice() {
    double? price;
    if (_currentMarketData != null) {
      price = _currentMarketData!.payload.bid;
    } else if (_currentMarketDetails != null) {
      price = _currentMarketDetails!.snapshot?.bid;
    }
    if (price != null) {
      return price;
    }
    return -1;
  }

  double _getCurrentSpread() {
    double? currentOffer;
    double? currentBid;
    if (_currentMarketData != null) {
      currentOffer = _currentMarketData!.payload.ofr;
      currentBid = _currentMarketData!.payload.bid;
    } else if (_currentMarketDetails != null) {
      currentOffer = _currentMarketDetails!.snapshot?.offer;
      currentBid = _currentMarketDetails!.snapshot?.bid;
    }
    if (currentBid != null && currentOffer != null) {
      return currentOffer - currentBid;
    }
    return -1;
  }

  double _getCurrentBuyPrice() {
    double? price;
    if (_currentMarketData != null) {
      price = _currentMarketData!.payload.ofr;
    } else if (_currentMarketDetails != null) {
      price = _currentMarketDetails!.snapshot?.offer;
    }
    if (price != null) {
      return price;
    }
    return -1;
  }

  double _getLastSellPrice() {
    double? price;
    if (_lastMarketData != null) {
      price = _lastMarketData!.payload.bid;
    } else if (_lastMarketDetails != null) {
      price = _lastMarketDetails!.snapshot?.bid;
    }
    if (price != null) {
      return price;
    }
    return -1;
  }

  int _getTrend() {
    int trend = 0;

    if (_getLastSellPrice() == -1 || _getCurrentSellPrice() == _getLastSellPrice()) return 0;

    if (_getLastSellPrice() > _getCurrentSellPrice()) {
      trend = -1;
    } else if (_getLastSellPrice() < _getCurrentSellPrice()) {
      trend = 1;
    }

    return trend;
  }

  Icon _getTrendIcon(int trend) {
    switch (trend) {
      case 1:
        return const Icon(Icons.arrow_circle_up, color: Colors.green, size: 55);
      case -1:
        return const Icon(Icons.arrow_circle_down, color: Colors.red, size: 55);
      default:
        return const Icon(Icons.pause_circle_outline,
            color: Colors.lightBlue, size: 55);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Scalping'),
      ),
      body: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Form(
            key: _epicFormKey,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    // StreamBuilder(
                    //   stream: _marketDetailsChannel.stream,
                    //   builder: (context, snapshot) {
                    //     return Text(snapshot.hasData ? '${snapshot.data}' : '');
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: _epicController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Epic name',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    StreamBuilder<dynamic>(
                      stream: _webSocketChannel.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = jsonDecode(snapshot.data);
                          if (data['status'] == 'OK' &&
                              data['payload']['epic'] != null) {
                            _lastMarketData = _currentMarketData;
                            _currentMarketData = MarketData.fromJson(data);
                          }
                        }
                        return Row(
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  'SELL: ${_getCurrentSellPrice() != -1 ? _getCurrentSellPrice() : '-'}'),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: _getTrendIcon(_getTrend()),
                            )),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 16),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  'BUY: ${_getCurrentBuyPrice() != -1 ? _getCurrentBuyPrice() : '-'}'),
                            )),
                          ],
                        );
                      },
                    ),
                    Column(
                      children: [
                        const Text('MARKET DETAILS'),
                        Text('Spread: ${_getCurrentSpread()}'),
                        Text(
                            'Min. deal size: ${_currentMarketDetails?.dealingRules?.minDealSize?.value}'),
                        Text(
                            'Min. step distance: ${_currentMarketDetails?.dealingRules?.minStepDistance?.value}'),
                        Text(
                            'Min. stop/profit distance: ${_currentMarketDetails?.dealingRules?.minStopOrProfitDistance?.value}'),
                        Text(
                            'Max. stop/profit distance: ${_currentMarketDetails?.dealingRules?.maxStopOrProfitDistance?.value}'),
                        Text('SELL: ${_getCurrentSellPrice()}'),
                        Text('BUY: ${_getCurrentBuyPrice()}')
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(
                                  50) // put the width and height you want
                              ),
                          onPressed: () {
                            if (_epicFormKey.currentState!.validate()) {
                              // If the form is valid, display a snackbar. In the real world,
                              // you'd often call a server or save the information in a database.
                              // Timer.periodic(const Duration(seconds: 1), (timer) {
                              _updateEpic(_epicController.text);
                              // });
                            }
                          },
                          child: const Text("Update epic")),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
