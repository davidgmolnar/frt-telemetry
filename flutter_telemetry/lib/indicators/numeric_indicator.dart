import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

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
  late final String label;

  @override
  void initState() {
      super.initState();
      if(labelRemap.containsKey(widget.subscribedSignal)){
        label = labelRemap[widget.subscribedSignal]!;
      }
      else{
        label = widget.subscribedSignal.replaceAll('_', ' ');
      }
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateData());
    }

  void updateData(){
    num? temp = signalValues[widget.subscribedSignal]?.last;
    if(temp != null && temp != value){
      setState(() {
        value = temp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(color: currentColor, borderRadius: BorderRadius.circular(10.0), border: Border.all(color: currentColor) ),
        child: InkWell(
          onTap: () {},
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
                child: Text(label,
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
                  Text(representNumber(value.toString()),
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}