import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';

class NumericIndicator extends StatefulWidget{
  const NumericIndicator({
  Key? key,
  required this.subscribedSignal,
  }) : super(key: key);

  final String subscribedSignal;

  @override
  State<StatefulWidget> createState() {
    return NumericIndicatorState();
  }

}

class NumericIndicatorState extends State<NumericIndicator>{
	late Timer timer;
  num value = 0;
  Color onHoverColor = primaryColor;
  Color defaultColor = bgColor;
  Color currentColor = bgColor;

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateData());
    }

  void updateData(){
    List? temp = signalValues[widget.subscribedSignal];
    if(temp!.isNotEmpty && temp[0] != value){
      setState(() {
        value = temp[0];
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: Text(widget.subscribedSignal,  // TODO remap
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: numericFontSize
                  ),
                ),
              ),
              Container(
                width: 100,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1.0, color: primaryColor),
                  )
                ),
                child:
                  Text(value.toStringAsPrecision(9),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(fontSize: numericFontSize),
                  ),
                )
            ],
          )
        )
      );
  }
}