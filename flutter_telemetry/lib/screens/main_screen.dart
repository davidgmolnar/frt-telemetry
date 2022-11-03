import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_view.dart';
import 'package:flutter_telemetry/components/dash_menu.dart';
import 'package:flutter_telemetry/constants.dart';

class MainScreen extends StatefulWidget{
  const MainScreen({
    Key? key,
    required this.getData,
    required this.connect
  }) : super(key: key);

  final Function getData;
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
            DashMenu(flexVal: 1, minFlex: 1, maxFlex: 1, connect: widget.connect,), //TODO
            ConfigView(flex: 9, text: "defaultText", getData: widget.getData)
          ],
        ),
      ),
    );
  }
}