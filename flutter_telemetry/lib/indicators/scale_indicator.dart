import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class ScaleIndicator extends StatefulWidget{
  const ScaleIndicator({
  Key? key,
  required this.subscribedSignal,
  required this.maxValue,
  required this.minValue,
  }) : super(key: key);

  final String subscribedSignal;
  final num maxValue;
  final num minValue;

  @override
  State<StatefulWidget> createState() {
    return ScaleIndicatorState();
  }
}

class ScaleIndicatorState extends State<ScaleIndicator>{
  late Timer timer;
  late num value;

  @override
  void initState() {
    value = widget.minValue;
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateData());
  }

  void updateData(){
    List? temp = signalValues[widget.subscribedSignal];
    if(temp!.isNotEmpty && temp.last != value){
      setState(() {
        value = temp.last;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 60, minHeight: 170),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              widget.subscribedSignal,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 130),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  width: 40,
                  height: normalizeInbetween(value, widget.minValue, widget.maxValue, 0, 130).toDouble(),
                ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              value.toStringAsPrecision(3),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

}