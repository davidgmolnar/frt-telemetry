import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';

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
  num value = 0;
  Color onHoverColor = primaryColor;
  Color defaultColor = bgColor;
  Color currentColor = bgColor;
  Color textColor = Colors.red;  // default

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateData());
    }

  void updateData(){
    List? temp = signalValues[widget.subscribedSignal];
    if(temp!.isNotEmpty && temp[0] != value){
      setState(() {
        if(temp[0] == 0){  // vagy fordítva idk TODO
        value = 0;
          textColor = const Color.fromARGB(255, 11, 177, 16);
        }
        else{
          value == 1;
          textColor = Colors.red;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(color: currentColor, borderRadius: BorderRadius.circular(10.0), border: Border.all(color: currentColor) ),
      child: InkWell(
        onHover: (isHovering){
          if(isHovering){
            setState(() {
              currentColor = onHoverColor;
            });
          }
          else{
            setState(() {
              currentColor = defaultColor;
            });
          }
        },
        child:
          Text(widget.subscribedSignal,  // TODO remap
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(fontSize: numericFontSize, color: textColor),),
      ),
    );
  }
}