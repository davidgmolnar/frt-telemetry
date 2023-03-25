import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class RotaryIndicator extends StatefulWidget{
  const RotaryIndicator({
  Key? key,
  required this.subscribedSignal,
  required this.numofStates,
  required this.granularity,
  required this.offset,
  }) : super(key: key);

  final String subscribedSignal;
  final num numofStates;
  final int granularity;
  final int offset;
  
  @override
  State<StatefulWidget> createState() {
    return RotaryIndicatorState();
  }
}

class RotaryIndicatorState extends State<RotaryIndicator>{
  late Timer timer;
  num value = 0;
  late String label;

  @override
  void initState() {
    super.initState();
    if(labelRemap.containsKey(widget.subscribedSignal)){
        label = labelRemap[widget.subscribedSignal]!;
      }
      else{
        label = widget.subscribedSignal.replaceAll('_', ' ');
      }
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    num? temp = signalValues[widget.subscribedSignal] != null && signalValues[widget.subscribedSignal]!.isNotEmpty ? signalValues[widget.subscribedSignal]?.last : null;
    if(temp != null && temp != value && (temp > 0 && temp < widget.numofStates)){
      setState(() {
        value = temp;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 250, minWidth: 250),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Transform.translate(
            offset: const Offset(0, -50),
            child: Transform.rotate(  // Needle
              angle: -0.75*pi + (value - widget.offset) * 1.5 * pi / (widget.numofStates - 1),
              origin: const Offset(0, 50),
              child: Container(
                width: 3,
                height: 100,
                color: primaryColor,
              ),
            ),
          ),

          Transform.translate(  // Label
            offset: const Offset(0, 115),
            child: Text(label),
          ),
        
          for(int i = 0; i < widget.numofStates; i+=widget.granularity)
            Transform.translate(  // Ticks
              offset: Offset.fromDirection(-1.25 * pi + i * 1.5 * pi / (widget.numofStates - 1), 115),
              child: Text("${i + widget.offset}"),),
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