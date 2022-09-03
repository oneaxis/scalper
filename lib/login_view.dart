import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scalper/scalping_view.dart';
import 'package:scalper/session.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _sessionFormKey = GlobalKey<FormState>();
  final _usernameFormController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiTokenController = TextEditingController();

  @override
  void initState() {
    _usernameFormController.text = 'timo_weber@outlook.com'; // TODO: remove
    _passwordController.text = 'x514^(pKc[~?8An.!E'; // TODO: remove
    _apiTokenController.text = 'YuuIoDi82OLCL2IQ'; // TODO: remove
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameFormController.dispose();
    _passwordController.dispose();
    _apiTokenController.dispose();
    super.dispose();
  }

  _onStartSessionError(error, context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
  }

  _onStartSessionSuccess(http.Response data, context) {
    final session = Session.fromJson(jsonDecode(data.body), data.headers);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Started session for account id: ${session.currentAccountId}')));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScalpingView(session: session),
      ),
    );
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
          title: const Text('Login'),
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
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                  child: Column(
                    children: [
                      Padding(
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
                      Padding(
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
                          )),
                      Padding(
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
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100,
                                    55) // put the width and height you want
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

                                _startSession(
                                    _usernameFormController.text,
                                    _passwordController.text,
                                    _apiTokenController.text);
                              }
                            },
                            child: const Text("Start session")),
                      )
                    ],
                  )),
            ),
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
