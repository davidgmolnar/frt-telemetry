import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class BooleanIndicator extends StatefulWidget{
  const BooleanIndicator({
  Key? key,
  required this.subscribedSignal,
  }) : super(key: key);

  final String subscribedSignal;

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
      timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateData());
    }

  void updateData(){
    num? temp = signalValues[widget.subscribedSignal]?.last;
    if(temp != null){
      setState(() {
        if(temp == 0){
          value = 0;
          textColor = const Color.fromARGB(255, 11, 177, 16);
        }
        else if(temp == 1){
          value == 1;
          textColor = Colors.red;
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
    return Container( 
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