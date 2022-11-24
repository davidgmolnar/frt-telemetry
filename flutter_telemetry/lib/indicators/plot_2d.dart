import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class Plot2D extends StatefulWidget{
  Plot2D({
  Key? key,
  required this.getSignalValues,
  required this.subscribedSignals,
  required this.title,
  required this.maxValue,
  required this.trailToKeep,
  }) : super(key: key);

  final Function getSignalValues;
  final String title;
  final num maxValue;
  final int trailToKeep;
  final List<String> subscribedSignals;
  
  @override
  State<StatefulWidget> createState() {
    return Plot2DState();
  }
}

class Plot2DState extends State<Plot2D>{
  late Timer timer;
  late List x;
  late List y;

  @override
  void initState() {
    for(int i = 0; i < widget.trailToKeep; i++){
      x.add(0);
      y.add(0);
    }
    
    print("x: $x");
    print("y: $y");

    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => update());
  }

  void update(){

  }
  
  @override
  Widget build(BuildContext context) {
    double innersize = 230;
    return Container(
      constraints: const BoxConstraints(minHeight: 300, minWidth: 300),
      child: InkWell(
        onTap: (){
          if(x.last >= 3){
            x.removeAt(0);
            x.add(-3);
            y.removeAt(0);
            y.add(-3);
          }
          else{
            num temp = x.last;
            x.removeAt(0);
            x.add(temp + 0.5);
            y.removeAt(0);
            y.add(temp + 0.5);
          }
          setState(() {
            
          });
          print("x: $x");
          print("y: $y");
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Transform.translate(
              offset: const Offset(0, -275),
              child: Text(widget.title),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
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
              
            for(int i = 0; i < widget.trailToKeep; i++)
              Transform.translate(
                offset: Offset(
                  1.0 * normalizeInbetween(x[i], -1 * widget.maxValue, widget.maxValue, -(innersize~/2).toInt(), (innersize~/2).toInt()),
                  -1.0 * normalizeInbetween(y[i], -1 * widget.maxValue, widget.maxValue, 0, innersize.toInt())
                ),
                child: Text(".", style: TextStyle(fontSize: 60, color: primaryColor.withOpacity(0 + i/(widget.trailToKeep - 1))),),
              )
          ],
        ),
      ),
    );
  }


}