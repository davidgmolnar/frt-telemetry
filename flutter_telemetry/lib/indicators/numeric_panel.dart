import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/indicators/numeric_indicator.dart';

class NumericPanel extends StatefulWidget{
  NumericPanel({
  Key? key,
  required this.getData,
  required this.subscribedSignals,
  required this.colsize,
  required this.title,
  required this.flex,
  }) : super(key: key);

  final Function getData;
  final List<String> subscribedSignals;
  final int colsize;
  final String title;
  final int flex;

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
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
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
                  Expanded(
                    child: Column(
                      children: [
                        for(int j = 0; j < widget.colsize && (i * widget.colsize + j) < widget.subscribedSignals.length; j++)
                          NumericIndicator(getData: widget.getData, subscribedSignal: widget.subscribedSignals[i * widget.colsize + j])
                      ]
                    )
                  )
                  
              ],
            ),
          ),
        ],
      )
    );
  }
}