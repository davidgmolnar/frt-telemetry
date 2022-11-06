import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

class BooleanIndicator extends StatefulWidget{
  BooleanIndicator({
  Key? key,
  required this.getData,
  required this.subscribedSignal,
  }) : super(key: key);

  final Function getData;
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
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => getDataWrapper());
    }

  void getDataWrapper(){
    num temp = widget.getData(widget.subscribedSignal, true)[0];
    if(temp != value){
      setState(() {
        if(value == 0){  // vagy fordítva idk TODO
          textColor = const Color.fromARGB(255, 11, 177, 16);
        }
        else{
          textColor = Colors.red;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: currentColor, borderRadius: BorderRadius.circular(10.0), border: Border.all(color: currentColor) ),
      child: InkWell(
        onTap:() {},
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
          Container( 
            constraints: const BoxConstraints(minWidth: 150),
            child: Text(widget.subscribedSignal,  // TODO remap
              textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(fontSize: numericFontSize, color: textColor),),
        ),
      ),
    );
  }
}