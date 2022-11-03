import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/numeric_indicator.dart';
import 'package:flutter_telemetry/constants.dart';

class ConfigView extends StatefulWidget{
    ConfigView({
    Key? key,
    required this.text,
    required this.getData,
    required this.flex,
  }) : super(key: key);

  String text;
  final Function getData;
  final int flex;

  @override
  State<StatefulWidget> createState() {
    return ConfigViewState();
  }
}

class ConfigViewState extends State<ConfigView>{
	late Timer timer;

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => getDataWrapper());
    }

  void getDataWrapper(){
    String temp = widget.getData("Bosch_yaw_rate", false).toString();
    if(temp != widget.text && temp.isNotEmpty){
      setState(() {
        widget.text = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Column(
        children: [
          NumericIndicator(flex: 1, getData: widget.getData, subscribedSignal: "Bosch_yaw_rate",)
        ],
      )
    );
  }
}