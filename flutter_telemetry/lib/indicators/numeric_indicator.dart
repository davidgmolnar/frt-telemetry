import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class NumericIndicator extends StatefulWidget{
  const NumericIndicator({
  Key? key,
  required this.subscribedSignal,
  }) : super(key: key);

  final String subscribedSignal;

  @override
  State<StatefulWidget> createState() {
    return NumericIndicatorState();
  }

}

class NumericIndicatorState extends State<NumericIndicator>{
	late Timer timer;
  num value = -1;
  late final String label;

  @override
  void initState() {
      super.initState();
      if(labelRemap.containsKey(widget.subscribedSignal.split(' ').first)){
        label = labelRemap[widget.subscribedSignal.split(' ').first]!;
      }
      else{
        label = widget.subscribedSignal.split(' ').first.replaceAll('_', ' ');
      }
      timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS']!.value), (Timer t) => updateData());
    }

  void updateData(){
    num? temp = signalValues[widget.subscribedSignal] != null && signalValues[widget.subscribedSignal]!.isNotEmpty ? signalValues[widget.subscribedSignal]?.last : null;
    if(temp != null && temp != value){
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
              child: AdvancedTooltip(
                tooltipText: "Listening to ${widget.subscribedSignal}",
                child: Text(label, textAlign: TextAlign.left, maxLines: 1, style: const TextStyle( fontSize: numericFontSize ),)
              )
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