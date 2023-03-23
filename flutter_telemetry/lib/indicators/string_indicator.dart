import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';

class StringIndicator extends StatefulWidget{
  const StringIndicator({
    Key? key,
    required this.subscribedSignal,
    required this.decoder,
  }) : super(key: key);

  final String subscribedSignal;
  final Function decoder;

  @override
  State<StatefulWidget> createState() {
    return StringIndicatorState();
  }

}

class StringIndicatorState extends State<StringIndicator>{
	late Timer timer;
  num value = 0;
  String display = "NOT SET";
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
      value = temp;
      display = widget.decoder(value);
      if(display == "INVALID"){
        terminalQueue.add(TerminalElement("Invalid value $value received for signal ${widget.subscribedSignal}", 2));
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Container(
              width: 150,
              padding: const EdgeInsets.only(right: defaultPadding),
              child: Text(label,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: numericFontSize
                ),
              ),
            ),
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.0, color: primaryColor),
                )
              ),
              child:
                Padding(
                  padding: const EdgeInsets.only(left: defaultPadding),
                  child: Text(display,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: const TextStyle(fontSize: numericFontSize),
                  ),
                ),
              )
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