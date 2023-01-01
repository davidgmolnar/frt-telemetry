import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_view.dart';
import 'package:flutter_telemetry/components/dash_menu.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({
    Key? key,
    required this.getSignalValues,
    required this.connect
  }) : super(key: key);

  final Function getSignalValues;
  final Function connect;

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen>{

	late Timer timer;

  @override
  void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            DashMenu(flexVal: 1, minFlex: 1, maxFlex: 3, connect: widget.connect,), //TODO becsukva csak ikonok legyenek
            ConfigView(getSignalValues: widget.getSignalValues),
          ],
        ),
      ),
    );
  }
}