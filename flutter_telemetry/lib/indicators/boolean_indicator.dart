import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class BooleanIndicator extends StatefulWidget{
  const BooleanIndicator({
  Key? key,
  required this.subscribedSignal, this.isInverted
  }) : super(key: key);

  final String subscribedSignal;
  final bool? isInverted; // null -> false, !null -> true

  @override
  State<StatefulWidget> createState() {
    return BooleanIndicatorState();
  }

}

class BooleanIndicatorState extends State<BooleanIndicator>{
	late Timer timer;
  num value = 1;
  Color textColor = Colors.red;  // default
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
    if(temp != null){
      setState(() {
        if(temp == 0){
          value = 0;
          textColor = widget.isInverted == null ? const Color.fromARGB(255, 11, 177, 16) : Colors.red;
        }
        else if(temp == 1){
          value == 1;
          textColor = widget.isInverted == null ? Colors.red : const Color.fromARGB(255, 11, 177, 16);
        }
        else{
          value = 2; // hiba
          textColor = Colors.black; // hiba
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding: const EdgeInsets.all(defaultPadding),
      child: Text(label,
        textAlign: TextAlign.left,
        maxLines: 1,
        style: TextStyle(fontSize: numericFontSize, color: textColor),),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}