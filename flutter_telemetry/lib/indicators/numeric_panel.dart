import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/indicators/numeric_indicator.dart';

class NumericPanel extends StatefulWidget{
  const NumericPanel({
  Key? key,
  required this.subscribedSignals,
  required this.colsize,
  required this.title,
  }) : super(key: key);

  final List<String> subscribedSignals;
  final int colsize;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return NumericPanelState();
  }

}

class NumericPanelState extends State<NumericPanel> {

  @override
  Widget build(BuildContext context) {
    int colcount = (widget.subscribedSignals.length / widget.colsize).ceil();
    return Container(
      constraints: BoxConstraints(maxWidth: colcount * widthPerColumnNumeric.toDouble()),
      padding: const EdgeInsets.all(defaultPadding),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(int i = 0; i < colcount; i++)
                  Flexible(
                    child: Column(
                      children: [
                        for(int j = 0; j < widget.colsize && (i * widget.colsize + j) < widget.subscribedSignals.length; j++)
                          NumericIndicator(subscribedSignal: widget.subscribedSignals[i * widget.colsize + j])
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