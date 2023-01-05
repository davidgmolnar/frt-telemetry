import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';

class RotaryIndicator extends StatefulWidget{
  const RotaryIndicator({
  Key? key,
  required this.subscribedSignal,
  required this.numofStates,
  }) : super(key: key);

  final String subscribedSignal;
  final num numofStates;
  
  @override
  State<StatefulWidget> createState() {
    return RotaryIndicatorState();
  }
}

class RotaryIndicatorState extends State<RotaryIndicator>{
  late Timer timer;
  num value = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateData());
  }

  void updateData(){
    List? temp = signalValues[widget.subscribedSignal];
    if(temp!.isNotEmpty && temp.last != value && (temp.last > 0 && temp.last < widget.numofStates)){
      setState(() {
        value = temp.last;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 170, minWidth: 250),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Transform.rotate(
            angle: -pi/2 + value * pi / (widget.numofStates - 1),
            origin: const Offset(0, 50-9),
            child: Container(
              width: 3,
              height: 100,
              color: primaryColor,
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -155),
            child: Text(widget.subscribedSignal),
          ),
        
          for(int i = 0; i < widget.numofStates; i++)
            Transform.translate(
              offset: Offset.fromDirection(-pi + i * pi / (widget.numofStates - 1), 115),
              child: Text("${i + 1}"),),
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