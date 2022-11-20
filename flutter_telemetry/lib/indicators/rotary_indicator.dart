import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

class RotaryIndicator extends StatefulWidget{
  RotaryIndicator({
  Key? key,
  required this.getSignalValues,
  required this.subscribedSignal,
  required this.numofStates,
  required this.flex,
  }) : super(key: key);

  final Function getSignalValues;
  final String subscribedSignal;
  final num numofStates;
  final int flex;
  
  @override
  State<StatefulWidget> createState() {
    return RotaryIndicatorState();
  }
}

class RotaryIndicatorState extends State<RotaryIndicator>{
  late Timer timer;
  int value = 0;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => update());
  }

  void update(){
    Map<String, List<dynamic>?> temp = widget.getSignalValues(widget.subscribedSignal, true, false);
    if(temp["values"]!.isNotEmpty && temp["values"]![0] != value && (temp["values"]![0] > 0 && temp["values"]![0] < widget.numofStates)){
      setState(() {
        value = temp["values"]![0];
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200, minWidth: 250),
      child: InkWell(
        onTap: () {
          setState(() {
            if(value < widget.numofStates - 1){
              value++;
            }
            else{
              value = 0;
            }
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Transform.rotate(
              angle: -pi/2 + value * pi / (widget.numofStates - 1),
              origin: const Offset(0, 50-3),
              child: Container(
                width: 3,
                height: 100,
                color: primaryColor,
              ),
            ),

            Transform.translate(
              offset: const Offset(0, -180),
              child: Text(widget.subscribedSignal),
            ),
      
            for(int i = 0; i < widget.numofStates; i++)
              Transform.translate(
                offset: Offset.fromDirection(-pi + i * pi / (widget.numofStates - 1), 120),
                child: Text("${i + 1}"),),
          ],
        ),
      )
    );
  }
}