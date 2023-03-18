import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class FourStateLed extends StatefulWidget{
  const FourStateLed({
    Key? key,
    required this.subscribedSignal,
    required this.paddingFactor
  }) : super(key: key);

  final String subscribedSignal;
  final int paddingFactor;

  @override
  State<StatefulWidget> createState() {
    return FourStateLedState();
  }

}

class FourStateLedState extends State<FourStateLed>{
	late Timer timer;
  num value = 1;
  Color textColor = Colors.grey.shade700;  // default
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
    if(temp != null && temp != value){
      setState(() {
        if(temp == 0){
          value = 0;
          textColor = const Color.fromARGB(255, 158, 158, 158);
        }
        else if(temp == 1){
          value == 1;
          textColor = const Color.fromARGB(255, 255, 17, 0);
        }
        else if(temp == 2){
          value = 2;
          textColor = const Color.fromARGB(255, 0, 255, 8);
        }
        else if(temp == 3){
          value = 3;
          textColor = const Color.fromARGB(255, 255, 152, 0);
        }
        else{
          value = 4; // hiba
          textColor = const Color.fromARGB(255, 0, 0, 0); // hiba
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: EdgeInsets.all(widget.paddingFactor * defaultPadding),
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