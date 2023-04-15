import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class Plot2D extends StatefulWidget{
  const Plot2D({
  Key? key,
  required this.subscribedSignals,
  required this.title,
  required this.maxValue,
  //this.trailToKeep = 3
  }) : super(key: key);

  final String title;
  final num maxValue;
  //final int trailToKeep;
  final List<String> subscribedSignals;
  
  @override
  State<StatefulWidget> createState() {
    return Plot2DState();
  }
}

class Plot2DState extends State<Plot2D>{
  late Timer timer;
  late List x = [0,0,0];
  late List y = [0,0,0];

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS']![0]), (Timer t) => updateData());
  }

  void updateData(){
    bool needsUpdate = false;
    num? tempX = signalValues[widget.subscribedSignals[0]] != null && signalValues[widget.subscribedSignals[0]]!.isNotEmpty ? signalValues[widget.subscribedSignals[0]]?.last : null;
    if(tempX != null){
      needsUpdate = true;
      x.removeAt(0);
      x.add(tempX); // buildben be van rakva a rangebe
    }
    num? tempY = signalValues[widget.subscribedSignals[1]] != null && signalValues[widget.subscribedSignals[1]]!.isNotEmpty ? signalValues[widget.subscribedSignals[1]]?.last : null;
    if(tempY != null){
      needsUpdate = true;
      y.removeAt(0);
      y.add(tempY); // buildben be van rakva a rangebe
    }
    if(needsUpdate){
      setState(() {
      
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double innersize = 300 * 0.75;
    return Container(
      constraints: const BoxConstraints(minHeight: 300, minWidth: 300),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Transform.translate(
            offset: const Offset(0, -300 * 0.85),
            child: Tooltip(
              message: "Listening to ${widget.subscribedSignals[0]} and ${widget.subscribedSignals[1]}",
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(5.0)
              ),
              textStyle: TextStyle(color: textColor),
              showDuration: Duration(milliseconds: tooltipShowMs),
              waitDuration: Duration(milliseconds: tooltipWaitMs),
              verticalOffset: 10,
              child: Text(widget.title)
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -300 * 0.07),
            child: Container(
              decoration: BoxDecoration(border: Border.all(color: primaryColor, width: 1.0)),
              width: innersize,
              height: innersize,
            ),
          ),
      
          for(int i = 0; i < 4; i++)
            Transform.translate(
              offset: Offset(0, -innersize/2 - 10),
              child: Transform.translate(
                offset: Offset.fromDirection(-pi/4 + i*pi/2, sqrt(2) * innersize/2 + 15),
                child: Text("(${xPrefix(i)}${widget.maxValue};${yPrefix(i)}${widget.maxValue})"),
              )
            ),
            
          for(int i = 0; i < 3; i++)
            Transform.translate(
              offset: Offset(
                1.0 * normalizeInbetween(x[i], -1 * widget.maxValue, widget.maxValue, -(innersize~/2).toInt(), (innersize~/2).toInt()),
                -1.0 * normalizeInbetween(y[i], -1 * widget.maxValue, widget.maxValue, 0, innersize.toInt())
              ),
              child: Text("•", style: TextStyle(fontSize: 30, color: primaryColor.withOpacity(0.2 + 0.8*(i/(2)))),),  
            )
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