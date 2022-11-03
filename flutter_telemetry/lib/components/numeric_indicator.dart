import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

class NumericIndicator extends StatefulWidget{
  NumericIndicator({
  Key? key,
  required this.getData,
  required this.flex,
  required this.subscribedSignal,
  }) : super(key: key);

  final Function getData;
  final int flex;
  final String subscribedSignal;

  @override
  State<StatefulWidget> createState() {
    return NumericIndicatorState();
  }

}

class NumericIndicatorState extends State<NumericIndicator>{
	late Timer timer;
  num value = 0;

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => getDataWrapper());
    }

  void getDataWrapper(){
    num temp = widget.getData(widget.subscribedSignal, true)[0];
    if(temp != value){
      setState(() {
        value = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children:[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text("${widget.subscribedSignal}:",
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(fontSize: numericFontSize),),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(value.toString(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(fontSize: numericFontSize),)
            ),
          ],
      ))
    );
  }

}