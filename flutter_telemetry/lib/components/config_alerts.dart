import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/dialogs/alert_add_dialog.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class TelemetryAlert{
  final String signal;
  final num min;
  final num max;
  final bool inRange;
  final UniqueKey id = UniqueKey();
  bool isActive = true;
  bool hasTriggered = false;
  num triggerValue = -1;

  TelemetryAlert(this.signal, this.min, this.max, this.inRange);

  bool _evaluateCondition(value){  // will trigger is condition is not met
    if(inRange){
      return value < min || value > max;
    }
    return value > min && value < max;
  }

  bool risingEdge(){
    if(hasTriggered || !isActive){
      return false;
    }
    num? value= signalValues[signal]?.last;
    if(value != null && _evaluateCondition(value)){
      triggerValue = value;
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          content: Text("Alert for signal $signal triggered with value $value")
        )
      );
      hasTriggered = true;
      return true;
    }
    return false;
  }

  Map<String, num> toJson(){
    return {
      "min": min,
      "max": max,
      "inRange": inRange ? 1 : 0,
      "isActive": isActive ? 1 : 0
    };
  }

  static TelemetryAlert fillFromJson(Map<String,dynamic> json, String setSignal){
    String signal = setSignal;
    num min = json["min"]!;
    num max = json["max"]!;
    bool inRange = json["inRange"] == 1 ? true : false;
    bool isActive = json["isActive"] == 1 ? true : false;
    return TelemetryAlert(signal, min, max, inRange)..isActive = isActive;
  }
}

class TelemetryAlertWidget extends StatefulWidget {
  const TelemetryAlertWidget({super.key, required this.alert, required this.onDelete});

  final TelemetryAlert alert;
  final Function onDelete;

  @override
  State<TelemetryAlertWidget> createState() => TelemetryAlertWidgetState();
}

class TelemetryAlertWidgetState extends State<TelemetryAlertWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      height: 50,
      child: Row(
        children: [
          Container(
            width: 260,
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(widget.alert.signal, style: TextStyle(color: widget.alert.hasTriggered ? Colors.red : Colors.green),),
          ),
          Container(
            width: 80,
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(widget.alert.hasTriggered ? representNumber(widget.alert.triggerValue.toString(), maxDigit: 8) : representNumber(signalValues[widget.alert.signal]!.last.toString(), maxDigit: 8)),
          ),
          Container(
            width: 110,
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(widget.alert.inRange ? "In range" : "Out of range", style: TextStyle(color: textColor),),
          ),
          Container(
            width: 160,
            padding: const EdgeInsets.all(defaultPadding),
            child: Text("${widget.alert.min} : ${widget.alert.max}", style: TextStyle(color: textColor),),
          ),
          IconButton(
            icon: Icon(widget.alert.isActive ? Icons.stop : Icons.play_arrow, color: primaryColor,),
            splashRadius: 20,
            onPressed: () {
              widget.alert.isActive = !widget.alert.isActive;
              alerts.where((element) => element.id == UniqueKey()).every((element) => element.isActive = !element.isActive);
              setState((){});
            },
          ),
          IconButton(
            icon: Icon(widget.alert.hasTriggered ? Icons.alarm : Icons.delete, color: primaryColor,),
            splashRadius: 20,
            onPressed: () {
              if(!widget.alert.hasTriggered){
                widget.onDelete();
              }
              else{
                widget.alert.hasTriggered = false;
                //widget.alert.isActive = true;
                setState((){});
              }
            },
          )
        ]
      )
    );
  }
}

class AlertContainer extends StatefulWidget {
  const AlertContainer({super.key});

  @override
  State<AlertContainer> createState() => AlertContainerState();
}

class AlertContainerState extends State<AlertContainer> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), ((timer) {
      setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Text("Alerts"),
            ),
            IconButton(
              icon: Icon(Icons.add, color: primaryColor,),
              splashRadius: 20,
              onPressed: () {
                showDialog<Widget>(
                    barrierDismissible: false,
                    context: tabContext,
                    builder: (BuildContext context) => const DialogBase(title: "New alert", dialog: AlertAddDialog(), minWidth: 520,)
                );
              },
            )
          ],
        ),
        Container(
          width: 700,
          height: 400,
          decoration: BoxDecoration(border: Border.all(color: primaryColor, width: 1.0)),
          child: ListView.builder(
            itemCount: alerts.length,
            itemExtent: 50,
            itemBuilder: (context, index) {
              return TelemetryAlertWidget(
                alert: alerts[index],
                onDelete: (){
                  alerts.removeAt(index);
                  setState(() {});
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel(); 
    super.dispose();
  }
}