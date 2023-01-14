import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/boolean_indicator.dart';

class BooleanPanel extends StatelessWidget{
  const BooleanPanel({
  Key? key,
  required this.subscribedSignals,
  required this.colsize,
  required this.title,
  }) : super(key: key);

  final List<String> subscribedSignals;
  final int colsize;
  final String title;

  @override
  Widget build(BuildContext context) {
    int colcount = (subscribedSignals.length / colsize).ceil();
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      constraints: BoxConstraints(maxWidth: colcount * widthPerColumnBoolean.toDouble()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: defaultPadding),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),)
          ),
          Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(width: 1.0, color: secondaryColor))),
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
                        for(int j = 0; j < colsize && (i * colsize + j) < subscribedSignals.length; j++)
                          BooleanIndicator(subscribedSignal: subscribedSignals[i * colsize + j])
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