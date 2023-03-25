import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class TelemetryAlert{
  String signal = "NO_KEYS";
  num min = -double.infinity;
  num max = double.infinity;
  bool inRange = true;
  final UniqueKey id = UniqueKey();
  bool isFinalized;
  bool isActive = true;
  bool hasTriggered = false;

  TelemetryAlert(this.isFinalized);

  bool _evaluateCondition(value){  // will trigger is condition is not met
    if(inRange){
      return value < min || value > max;
    }
    return value > min && value < max;
  }

  bool risingEdge(){
    if(hasTriggered || !isActive || !isFinalized){
      return false;
    }
    List<dynamic>? tmp = signalValues[signal];
    if(tmp != null && tmp.any((element) => _evaluateCondition(element))){
      snackbarKey.currentState?.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.red,
          content: Text("Alert for signal $signal triggered")
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
      "isFinalized": isFinalized ? 1 : 0,
      "isActive": isActive ? 1 : 0
    };
  }

  TelemetryAlert fillFromJson(Map<String,dynamic> json, String setSignal){
    signal = setSignal;
    if(json.containsKey("min") && json.containsKey("max") && json.containsKey("inRange") && json.containsKey("isFinalized") && json.containsKey("isActive")){
      min = json["min"]!;
      max = json["max"]!;
      inRange = json["inRange"] == 1 ? true : false;
      isFinalized = json["isFinalized"] == 1 ? true : false;
      isActive = json["isActive"] == 1 ? true : false;
    }
    return this;
  }
}

class TelemetryAlertWidget extends StatefulWidget {
  TelemetryAlertWidget({super.key, required this.alert, required this.onDelete});

  TelemetryAlert alert;
  final Function onDelete;

  @override
  State<TelemetryAlertWidget> createState() => TelemetryAlertWidgetState();
}

class TelemetryAlertWidgetState extends State<TelemetryAlertWidget> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 1000), (Timer t) => update());
  }

  void update(){
    if(!widget.alert.isFinalized){
      return;
    }
    if(widget.alert.risingEdge()){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 700,
      height: 50,
      child: Row(
        children: !widget.alert.isFinalized ? 
          [
            Container(
              padding: const EdgeInsets.all(defaultPadding),
              width: 330,
              child: DropdownButton(
                underline: Container(),
                icon: Icon(Icons.arrow_drop_down, color: primaryColor, size: 19),
                value: signalValues.keys.isNotEmpty ? (widget.alert.signal == "NO_KEYS" ? signalValues.keys.toList().sorted((a, b) => a.compareTo(b)).first : widget.alert.signal) : "NO_KEYS",
                items: signalValues.keys.isNotEmpty ?
                  signalValues.keys.toList().sorted((a, b) => a.compareTo(b)).map((e) => DropdownMenuItem(value: e, child: Text(e))).toList()
                  :
                  [const DropdownMenuItem(value: "NO_KEYS", child: Text("NO_KEYS"))],
                onChanged: (value) {
                  if(value != null){
                    widget.alert.signal = value;
                    setState(() {});
                  }
                },
              ),
            ),
            Container(
              width: 80,
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  hintText: "MIN",
                  hintStyle: const TextStyle(color: Colors.grey)
                ),
                onChanged:(value) {
                  try{
                    widget.alert.min = num.parse(value);
                  }
                  catch (_){}
                },
              ),
            ),
            Container(
              width: 80,
              padding: const EdgeInsets.all(defaultPadding),
              child: TextFormField(
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                  enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                  hintText: "MAX",
                  hintStyle: const TextStyle(color: Colors.grey)
                ),
                onChanged:(value) {
                  try{
                    widget.alert.max = num.parse(value);
                  }
                  catch (_){}
                },
              ),
            ),
            SizedBox(
              width: 110,
              child: TextButton(
                onPressed: () {
                  widget.alert.inRange = !widget.alert.inRange;
                  setState((){});
                },
                child: Text(widget.alert.inRange ? "In range" : "Out of range", style: TextStyle(color: primaryColor),),
              ),
            ),
            SizedBox(
              width: 40,
              child: IconButton(
                splashRadius: 20,
                icon: Icon(Icons.check, color: primaryColor),
                onPressed: () {
                  if(widget.alert.signal == "NO_KEYS"){
                    showError(context, "Please select a signal");
                    return;
                  }
                  if(widget.alert.min > widget.alert.max){
                    showError(context, "Min > max ?");
                    return;
                  }
                  widget.alert.isFinalized = true;
                  setState((){});
                },
              ),
            ),
            IconButton(
              splashRadius: 20,
              icon: Icon(Icons.delete, color: primaryColor,),
              onPressed: () { widget.onDelete(); },
            )
          ]
          :
          [
            Container(
              width: 330,
              padding: const EdgeInsets.all(defaultPadding),
              child: Text(widget.alert.signal, style: TextStyle(color: widget.alert.hasTriggered ? Colors.red : Colors.green),),
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
                  widget.alert.isActive = true;
                  setState((){});
                }
              },
            )
          ]
      )
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

class AlertContainer extends StatefulWidget {
  const AlertContainer({super.key});

  @override
  State<AlertContainer> createState() => AlertContainerState();
}

class AlertContainerState extends State<AlertContainer> {
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
                alerts.insert(0, TelemetryAlert(false));
                setState(() {});
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
}