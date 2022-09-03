import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scalper/market_details.dart';
import 'package:scalper/session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scalper',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'SCALPER'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _sessionFormKey = GlobalKey<FormState>();
  final _epicFormKey = GlobalKey<FormState>();
  Session? _session;
  MarketDetails? _currentMarketDetails, _lastMarketDetails;
  final _usernameFormController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiTokenController = TextEditingController();
  final _epicController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameFormController.dispose();
    _passwordController.dispose();
    _apiTokenController.dispose();
    _epicController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  _onStartSessionError(error, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }

  _onStartSessionSuccess(http.Response data, context) {
    setState(() {
      _session = Session.fromJson(jsonDecode(data.body), data.headers);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Started session for account id: ${_session?.currentAccountId}')));
  }

  _getMarketDetails(epicName) {
    http
        .get(
          Uri.parse(
              'https://demo-api-capital.backend-capital.com/api/v1/markets/$epicName'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-SECURITY-TOKEN': _session!.securityToken,
            'CST': _session!.cst
          },
        )
        .then((data) => {_onGetMarketDetailsSuccess(data, context)})
        .catchError((error) => {_onGetMarketDetailsError(error, context)});
  }

  _startSession(identifier, password, apiKey) {
    http
        .post(
          Uri.parse(
              'https://demo-api-capital.backend-capital.com/api/v1/session'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-CAP-API-KEY': apiKey
          },
          body: jsonEncode(<String, String>{
            'identifier': identifier,
            'password': password,
            'encryptionKey': 'false'
          }),
        )
        .then((data) => {_onStartSessionSuccess(data, context)})
        .catchError((error) => {_onStartSessionError(error, context)});
  }

  _onGetMarketDetailsSuccess(http.Response data, BuildContext context) {
    setState(() {
      _currentMarketDetails = MarketDetails.fromJson(jsonDecode(data.body));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Current bid price: ${_currentMarketDetails!.snapshot?.bid}')),
    );
  }

  _onGetMarketDetailsError(dynamic error, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  double _getCurrentSellPrice() {
    return _currentMarketDetails?.snapshot?.bid ?? -1;
  }

  double _getCurrentBuyPrice() {
    return _currentMarketDetails?.snapshot?.offer ?? -1;
  }

  double _getLastSellPrice() {
    return _lastMarketDetails?.snapshot?.bid ?? -1;
  }

  int _getTrend() {
    int trend = 0;

    if (_lastMarketDetails?.instrument?.epic !=
        _currentMarketDetails?.instrument?.epic) return 0;

    if (_getLastSellPrice() > _getCurrentSellPrice()) {
      trend = -1;
    } else if (_getLastSellPrice() < _getCurrentSellPrice()) {
      trend = 1;
    }

    _lastMarketDetails = _currentMarketDetails;
    return trend;
  }

  Icon _getTrendIcon(int trend) {
    switch (trend) {
      case 1:
        return const Icon(Icons.arrow_circle_up, color: Colors.green, size: 55);
      case -1:
        return const Icon(Icons.arrow_circle_down, color: Colors.red, size: 55);
      default:
        return const Icon(Icons.remove_circle_outline,
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
        title: Text(widget.title),
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
              key: _sessionFormKey,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextFormField(
                          controller: _usernameFormController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Field is required!';
                            }
                            return null;
                          },
                        )),
                  ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is required!';
                              }
                              return null;
                            },
                          ))),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: TextFormField(
                            controller: _apiTokenController,
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            decoration: const InputDecoration(
                              labelText: 'API Token',
                              border: OutlineInputBorder(),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Field is required!';
                              }
                              return null;
                            },
                          ))),
                ],
              )),
          Form(
              key: _epicFormKey,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                ],
              )),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                            100, 55) // put the width and height you want
                        ),
                    onPressed: () {
                      if (_sessionFormKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text('Starting session...')),
                        );

                        _startSession(_usernameFormController.text,
                            _passwordController.text, _apiTokenController.text);
                      }
                    },
                    child: const Text("Start session")),
              )),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: OutlinedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                            100, 55) // put the width and height you want
                        ),
                    onPressed: () {
                      if (_epicFormKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        _getMarketDetails(_epicController.text);
                      }
                    },
                    child: const Text("Watch epic")),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    'SELL: ${_getCurrentSellPrice()}'),
              )),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: _getTrendIcon(_getTrend()),
              )),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    'BUY: ${_getCurrentBuyPrice()}'),
              )),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        tooltip: 'Scalp',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
