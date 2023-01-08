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
  num value = 1;
  Color onHoverColor = primaryColor;
  Color defaultColor = bgColor;
  Color currentColor = bgColor;
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
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateData());
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
        child:
          Text(label,
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(fontSize: numericFontSize, color: textColor),),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}