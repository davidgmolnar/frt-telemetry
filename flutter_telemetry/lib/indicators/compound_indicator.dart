import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class CompoundIndicator extends StatefulWidget{
  const CompoundIndicator({
  Key? key,
  required this.firstSignal,
  required this.secondSignal,
  required this.rule,
  required this.title,
  }) : super(key: key);

  final String firstSignal;
  final String secondSignal;
  final Function rule;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return CompoundIndicatorState();
  }

}

class CompoundIndicatorState extends State<CompoundIndicator>{
	late Timer timer;
  num value = 0;

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS']![0]), (Timer t) => updateData());
    }

  void updateData(){
    num? first = signalValues[widget.firstSignal]?.last;
    num? second = signalValues[widget.secondSignal]?.last;
    if(first == null || second == null){
      return;
    }
    num temp = widget.rule(first, second);
    if(temp != value){
      setState(() {
        value = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Padding(
              padding: const EdgeInsets.only(right: defaultPadding),
              child: Text(widget.title,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: numericFontSize
                ),
              ),
            ),
            Container(
              width: 100,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.0, color: primaryColor),
                )
              ),
              child:
                Text(representNumber(value.toString()),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(fontSize: numericFontSize),
                ),
              )
          ],
        )
      );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}