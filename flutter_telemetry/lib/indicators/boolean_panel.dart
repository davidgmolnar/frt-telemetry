import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/indicators/boolean_indicator.dart';

class BooleanPanel extends StatefulWidget{
  const BooleanPanel({
  Key? key,
  required this.subscribedSignals,
  required this.colsize,
  required this.title,
  required this.flex
  }) : super(key: key);

  final List<String> subscribedSignals;
  final int colsize;
  final String title;
  final int flex;

  @override
  State<StatefulWidget> createState() {
    return BooleanPanelState();
  }

}

class BooleanPanelState extends State<BooleanPanel> {

  @override
  Widget build(BuildContext context) {
    int colcount = (widget.subscribedSignals.length / widget.colsize).ceil();
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      constraints: BoxConstraints(maxWidth: colcount * widthPerColumnBoolean.toDouble()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),)
          ),
          Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(width: 1.0, color: secondaryColor))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(int i = 0; i < colcount; i++)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for(int j = 0; j < widget.colsize && (i * widget.colsize + j) < widget.subscribedSignals.length; j++)
                          BooleanIndicator(subscribedSignal: widget.subscribedSignals[i * widget.colsize + j])
                      ]
                    ),
                  )
                  
              ],
            ),
          ),
        ],
      )
    );
  }
}