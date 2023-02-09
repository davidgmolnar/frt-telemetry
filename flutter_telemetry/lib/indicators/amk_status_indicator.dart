import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class AMKStatusIndicator extends StatefulWidget{
  const AMKStatusIndicator({super.key, required this.subscribedSignal});

  final String subscribedSignal;

  @override
  State<StatefulWidget> createState() {
    return AMKStatusIndicatorState();
  }
}

class AMKStatusIndicatorState extends State<AMKStatusIndicator>{
  late Timer timer;
  int value = -1;
  List<int?> bits = [1, 1, 1, 1, 1, 1, 1, 1];

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(Duration(milliseconds: settings['refreshTimeMS'][0]), (Timer t) => updateData());
    }

  void updateData(){
    num? temp = signalValues[widget.subscribedSignal]?.last;
    if(temp != null && temp != value && temp >= 0 && temp <= 256){
      value = temp.toInt();
      String bitString = value.toRadixString(2);
      bitString.padLeft(8, '0');
      bitString.characters.toList().asMap().forEach((idx, char) {
        bits[idx] = int.tryParse(char);
        if(bits[idx] == null){
          bits[idx] == 1; // TODO 2 és akkor valami más színű
        }
      },);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
        [
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("SysReady", style: TextStyle(color: bits[0] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("Error", style: TextStyle(color: bits[1] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("Warn", style: TextStyle(color: bits[2] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("QuitDcOn", style: TextStyle(color: bits[3] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("DcOn", style: TextStyle(color: bits[4] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("QuitInvOn", style: TextStyle(color: bits[5] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("InverterOn", style: TextStyle(color: bits[6] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
          Padding(padding: const EdgeInsets.all(defaultPadding),
            child: Text("Derating", style: TextStyle(color: bits[7] == 1 ? Colors.red : const Color.fromARGB(255, 11, 177, 16)),),
          ),
        ]
    );
  }

}