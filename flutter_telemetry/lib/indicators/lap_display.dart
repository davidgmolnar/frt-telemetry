import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class LapData{
  const LapData(this.lapNum, this.lapTimeMS, this.soc, this.currentAvg, this.motorTemps, this.invTemps);

  final int lapNum;
  final int lapTimeMS;
  final double soc;
  final double currentAvg;
  final List<double> motorTemps;
  final List<double> invTemps;

  Widget asWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 100, child: Text(representNumber(lapNum.toString()))),
        SizedBox(width: 100, child: Text(representMS(lapTimeMS))),
        SizedBox(width: 100, child: Text(representNumber(soc.toString()))),
        SizedBox(width: 100, child: Text(representNumber(currentAvg.toString()))),
        SizedBox(width: 100, child: Text(representNumber(motorTemps[0].toString()))),
        SizedBox(width: 100, child: Text(representNumber(motorTemps[1].toString()))),
        SizedBox(width: 100, child: Text(representNumber(motorTemps[2].toString()))),
        SizedBox(width: 100, child: Text(representNumber(motorTemps[3].toString()))),
        SizedBox(width: 100, child: Text(representNumber(invTemps[0].toString()))),
        SizedBox(width: 100, child: Text(representNumber(invTemps[1].toString()))),
        SizedBox(width: 100, child: Text(representNumber(invTemps[2].toString()))),
        SizedBox(width: 100, child: Text(representNumber(invTemps[3].toString()))),
      ],
    );
  }
}

String representMS(int ms){
  int sec = ms ~/ 1000;
  int min = sec ~/ 60;
  sec = sec - min * 60;
  ms = ms - sec * 1000;
  return "${min < 10 ? "0$min" : min}:${sec < 10 ? "0$sec" : sec}.${ms > 100 ? ms : ms > 10 ? "0$ms" : "00$ms"}";
}

LapData lapDataFromCurrent(lapTimeMS){
  double currentAvg = -1;
  if(lapHVCurrent.isNotEmpty){
    currentAvg = lapHVCurrent.reduce((value, element) => value + element) / lapHVCurrent.length;
    lapHVCurrent.clear();
  }
  return LapData(
    lapData.isEmpty ? 1 : lapData.last.lapNum + 1,
    lapTimeMS,
    signalValues.containsKey("State_of_Charge") && signalValues["State_of_Charge"]!.isNotEmpty ? signalValues["State_of_Charge"]!.last.toDouble() : -1,
    currentAvg,
    [
      signalValues.containsKey("AMK1_temp_motor") && signalValues["AMK1_temp_motor"]!.isNotEmpty ? signalValues["AMK1_temp_motor"]!.last.toDouble() : -1,
      signalValues.containsKey("AMK2_temp_motor") && signalValues["AMK2_temp_motor"]!.isNotEmpty ? signalValues["AMK2_temp_motor"]!.last.toDouble() : -1,
      signalValues.containsKey("AMK3_temp_motor") && signalValues["AMK3_temp_motor"]!.isNotEmpty ? signalValues["AMK3_temp_motor"]!.last.toDouble() : -1,
      signalValues.containsKey("AMK4_temp_motor") && signalValues["AMK4_temp_motor"]!.isNotEmpty ? signalValues["AMK4_temp_motor"]!.last.toDouble() : -1
    ],
    [
      signalValues.containsKey("AMK1_temp_inverter") && signalValues["AMK1_temp_inverter"]!.isNotEmpty ? signalValues["AMK1_temp_inverter"]!.last.toDouble() : -1,
      signalValues.containsKey("AMK2_temp_inverter") && signalValues["AMK2_temp_inverter"]!.isNotEmpty ? signalValues["AMK2_temp_inverter"]!.last.toDouble() : -1,
      signalValues.containsKey("AMK3_temp_inverter") && signalValues["AMK3_temp_inverter"]!.isNotEmpty ? signalValues["AMK3_temp_inverter"]!.last.toDouble() : -1,
      signalValues.containsKey("AMK4_temp_inverter") && signalValues["AMK4_temp_inverter"]!.isNotEmpty ? signalValues["AMK4_temp_inverter"]!.last.toDouble() : -1
    ],
  );
}

class LapDisplay extends StatefulWidget{
  const LapDisplay({super.key});

  @override
  State<StatefulWidget> createState() {
    return LapDisplayState();
  }
}

class LapDisplayState extends State<LapDisplay>{
  Timer timer = Timer(const Duration(days: 1), (() {}));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  lapTimerStarted = true;
                  lapData.clear();
                  lapStart = DateTime.now();
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(lapTimerStarted ? "Reset" : "Start timer"),
                    const SizedBox(width: 10,),
                    Icon(lapTimerStarted ? Icons.clear : Icons.start),
                    SizedBox(width: lapTimerStarted ? 10 : 0,),
                    Text(lapTimerStarted ? "Started at ${lapStart.hour}:${lapStart.minute}:${lapStart.second}": "")
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  useAutoTrigger = !useAutoTrigger;
                  if(useAutoTrigger){
                    // TODO Timer start
                  }
                  else{
                    if(timer.isActive){
                      timer.cancel();
                    }
                  }
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(useAutoTrigger ? "Auto" : "Manual"),
                    const SizedBox(width: 10,),
                    Icon(useAutoTrigger ? Icons.auto_mode : Icons.add),
                  ],
                ),
              ),
              !useAutoTrigger ? 
                TextButton(
                  onPressed: (){
                    if(!lapTimerStarted){
                      return;
                    }
                    DateTime lapEnd = DateTime.now();
                    lapData.add(lapDataFromCurrent(lapEnd.difference(lapStart).inMilliseconds));
                    lapStart = lapEnd;
                    setState(() {});
                  },
                  child: Row(
                    children: const [
                      Text("Lap"),
                      SizedBox(width: 10,),
                      Icon(Icons.add_alarm),                      
                    ]
                  )
                )
                :
                const SizedBox(width: 0,)
            ],
          ),
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
            padding: const EdgeInsets.all(defaultPadding),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SizedBox(width: 100, child: Text("Lap")),
              SizedBox(width: 100, child: Text("Laptime")),
              SizedBox(width: 100, child: Text("SoC")),
              SizedBox(width: 100, child: Text("Current avg")),
              SizedBox(width: 100, child: Text("FL Motor T")),
              SizedBox(width: 100, child: Text("FR Motor T")),
              SizedBox(width: 100, child: Text("RL Motor T")),
              SizedBox(width: 100, child: Text("RR Motor T")),
              SizedBox(width: 100, child: Text("FL Inv T")),
              SizedBox(width: 100, child: Text("FR Inv T")),
              SizedBox(width: 100, child: Text("RL Inv T")),
              SizedBox(width: 100, child: Text("RR Inv T")),
            ],
          ),
          for(LapData data in lapData)
            data.asWidget()
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
