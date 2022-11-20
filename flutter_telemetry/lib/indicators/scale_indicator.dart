import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class ScaleIndicator extends StatefulWidget{
  ScaleIndicator({
  Key? key,
  required this.getData,
  required this.subscribedSignal,
  required this.maxValue,
  required this.minValue,
  required this.flex,
  }) : super(key: key);

  final Function getData;
  final String subscribedSignal;
  final num maxValue;
  final num minValue;
  final int flex;

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
    timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => getDataWrapper());
  }

  void getDataWrapper(){
    Map<String, List<dynamic>?> temp = widget.getData(widget.subscribedSignal, true, false);
    if(temp["values"]!.isNotEmpty && temp["values"]![0] != value && (temp["values"]![0] > widget.minValue && temp["values"]![0] < widget.maxValue)){
      setState(() {
        value = temp["values"]![0];
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 70, minHeight: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              widget.subscribedSignal,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minHeight: 150),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  width: 50,
                  height: normalizeInbetween(value, widget.minValue, widget.maxValue, 0, 150).toDouble(),
                ),
              ]
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

}