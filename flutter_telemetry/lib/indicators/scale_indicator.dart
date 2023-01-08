import 'dart:async';

import 'package:decimal/decimal.dart';
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
  late String label;

  @override
  void initState() {
    value = widget.minValue;
    super.initState();
    if(labelRemap.containsKey(widget.subscribedSignal)){
        label = labelRemap[widget.subscribedSignal]!;
      }
      else{
        label = widget.subscribedSignal.replaceAll('_', ' ');
      }
    timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateData());
  }

  void updateData(){
    num? temp = signalValues[widget.subscribedSignal]?.last;
    if(temp != null && temp != value){
      setState(() {
        value = temp;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 120),
            color: secondaryColor,
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  width: 40,
                  height: normalizeInbetween(value, widget.minValue, widget.maxValue, 0, 120).toDouble(),
                ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              Decimal.parse(value.toString()).toStringAsPrecision(4),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.clip,
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