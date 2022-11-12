import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

class NumericIndicator extends StatefulWidget{
  NumericIndicator({
  Key? key,
  required this.getData,
  required this.subscribedSignal,
  }) : super(key: key);

  final Function getData;
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
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => getDataWrapper());
    }

  void getDataWrapper(){
    List<dynamic> temp = widget.getData(widget.subscribedSignal, true);
    if(temp.isNotEmpty && temp[0] != value){
      setState(() {
        value = temp[0];
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
        child: Row(
          children:[
            Expanded(
              child :Row(
                children:[
                  Container( 
                    constraints: const BoxConstraints(minWidth: 150),// TODO ezt majd lehet meg kéne oldani jobban
                    child: Text(widget.subscribedSignal,  // TODO remap
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      style: const TextStyle(fontSize: numericFontSize),),
                  ),
                  const SizedBox(width: 6),
                ]
              ),
            ),
            Container(
              width: 100,
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.0, color: primaryColor),
                )
              ),
              child: Row(
                children: [
                  const SizedBox(width: 6),
                  Text(value.toStringAsPrecision(9),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: const TextStyle(fontSize: numericFontSize),
                  ),
                ],
              )
            )
          ],
        )
      )
    );
  }
}