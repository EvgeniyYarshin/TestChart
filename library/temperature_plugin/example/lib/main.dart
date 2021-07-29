// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:temperature_plugin/temperature_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TemperaturePlugin _battery = TemperaturePlugin();
  late StreamSubscription<int> _temperatureStateSubscription;
  int temperature = 0;

  @override
  void initState() {
    super.initState();
    _temperatureStateSubscription =
        _battery.onTemperatureStateChanged.listen((int state) {
          setState(() {
            temperature = state;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Text('$temperature'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _temperatureStateSubscription.cancel();
  }
}
