import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/dialogs/dialog.dart';
import 'package:flutter_telemetry/dialogs/lapdata_save_dialog.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

class LapData{
  const LapData(this.lapNum, this.lapTimeMS, this.soc, this.deltasoc, this.mivCellVolt, this.motorTemps, this.invTemps);

  final int lapNum;
  final int lapTimeMS;
  final double soc;
  final double deltasoc;
  final double mivCellVolt;
  final List<double> motorTemps;
  final List<double> invTemps;

  Widget asWidget(bool isSmallScreen){
    if(isSmallScreen){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: 50, child: Text(representNumber(lapNum.toString(), maxDigit: 5))),
          SizedBox(width: 80, child: Text(representMS(lapTimeMS))),
          SizedBox(width: 50, child: Text(representNumber(soc.toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(deltasoc.toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(mivCellVolt.toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(motorTemps[0].toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(motorTemps[1].toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(motorTemps[2].toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(motorTemps[3].toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(invTemps[0].toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(invTemps[1].toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(invTemps[2].toString(), maxDigit: 5))),
          SizedBox(width: 50, child: Text(representNumber(invTemps[3].toString(), maxDigit: 5))),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(width: 50, child: Text(representNumber(lapNum.toString()))),
        SizedBox(width: 100, child: Text(representMS(lapTimeMS))),
        SizedBox(width: 100, child: Text(representNumber(soc.toString()))),
        SizedBox(width: 100, child: Text(representNumber(deltasoc.toString()))),
        SizedBox(width: 100, child: Text(representNumber(mivCellVolt.toString()))),
        SizedBox(width: 90, child: Text(representNumber(motorTemps[0].toString()))),
        SizedBox(width: 90, child: Text(representNumber(motorTemps[1].toString()))),
        SizedBox(width: 90, child: Text(representNumber(motorTemps[2].toString()))),
        SizedBox(width: 90, child: Text(representNumber(motorTemps[3].toString()))),
        SizedBox(width: 90, child: Text(representNumber(invTemps[0].toString()))),
        SizedBox(width: 90, child: Text(representNumber(invTemps[1].toString()))),
        SizedBox(width: 90, child: Text(representNumber(invTemps[2].toString()))),
        SizedBox(width: 90, child: Text(representNumber(invTemps[3].toString()))),
      ],
    );
  }
}

String representMS(int ms){
  int sec = ms ~/ 1000;
  int min = sec ~/ 60;
  sec = sec - min * 60;
  ms = ms - sec * 1000 - min * 60000;
  return "${min < 10 ? "0$min" : min}:${sec < 10 ? "0$sec" : sec}.${ms > 100 ? ms : ms > 10 ? "0$ms" : "00$ms"}";
}

LapData lapDataFromCurrent(int lapTimeMS, bool clear){
  final double soc = signalValues.containsKey("State_of_Charge") && signalValues["State_of_Charge"]!.isNotEmpty ? signalValues["State_of_Charge"]!.last.toDouble() : -1;
  final double deltasoc = lapData.isEmpty ? 0 : soc - lapData.last.soc;
  return LapData(
    lapData.isEmpty ? 1 : lapData.last.lapNum + 1,
    lapTimeMS,
    soc,
    deltasoc,
    signalValues.containsKey("HV_Cell_Voltage_MIN") && signalValues["HV_Cell_Voltage_MIN"]!.isNotEmpty ? signalValues["HV_Cell_Voltage_MIN"]!.last.toDouble() : -1,
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

class LapDataTracker extends StatefulWidget{
  const LapDataTracker({super.key, required this.isSmallScreen});

  final bool isSmallScreen;

  @override
  State<StatefulWidget> createState() {
    return LapDataTrackerState();
  }
}

class LapDataTrackerState extends State<LapDataTracker>{
  late Timer timer;
  late LapData lapDataTrack;

  @override
  void initState() {
    super.initState();
    lapDataTrack = lapDataFromCurrent(DateTime.now().difference(lapStart).inMilliseconds, false);
    timer = Timer.periodic(const Duration(milliseconds: 16), ((timer) {
      lapDataTrack = lapDataFromCurrent(DateTime.now().difference(lapStart).inMilliseconds, false);
      setState(() {});
    }));
  }

  @override
  Widget build(BuildContext context) {
    return lapDataTrack.asWidget(widget.isSmallScreen);
  }

  @override
  void dispose() {
    if(timer.isActive){
      timer.cancel();
    }
    super.dispose();
  }
}

class LapDisplay extends StatefulWidget{
  const LapDisplay({super.key, required this.isSmallScreen});

  final bool isSmallScreen;

  @override
  State<StatefulWidget> createState() {
    return LapDisplayState();
  }
}

class LapDisplayState extends State<LapDisplay>{
  ScrollController controller = ScrollController();

  void update(){
    setState(() {});
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
                  if(!lapTimerStarted && lapData.isNotEmpty){
                    showDialog<Widget>(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => DialogBase(title: "Lap tracking restart", dialog: LapDataSaveDialog(updater: update,), minWidth: 300,)
                    );
                  }
                  else{
                    lapTimerStarted = !lapTimerStarted;
                    if(lapTimerStarted){
                      lapStart = DateTime.now();
                    }
                    setState(() {});
                  }
                },
                child: Row(
                  children: [
                    Text(lapTimerStarted ? "Stop" : "Start timer", style: TextStyle(color: primaryColor, fontSize: subTitleFontSize),),
                    const SizedBox(width: 10,),
                    Icon(lapTimerStarted ? Icons.clear : Icons.start, color: primaryColor, size: subTitleFontSize,),
                    SizedBox(width: lapTimerStarted ? 10 : 0,),
                    Text(lapTimerStarted ? "Started at ${lapStart.hour < 10 ? "0${lapStart.hour}" : lapStart.hour}:${lapStart.minute < 10 ? "0${lapStart.minute}" : lapStart.minute}:${lapStart.second < 10 ? "0${lapStart.second}" : lapStart.second}": "", style: TextStyle(color: primaryColor, fontSize: subTitleFontSize),)
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  useAutoTrigger = !useAutoTrigger;
                  // TODO
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(useAutoTrigger ? "Auto - WIP" : "Manual", style: TextStyle(color: primaryColor, fontSize: subTitleFontSize),),
                    const SizedBox(width: 10,),
                    Icon(useAutoTrigger ? Icons.auto_mode : Icons.add, color: primaryColor, size: subTitleFontSize,),
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
                    lapData.add(lapDataFromCurrent(lapEnd.difference(lapStart).inMilliseconds, true));
                    lapStart = lapEnd;
                    controller.animateTo(lapData.length * 30, duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
                    setState(() {});
                  },
                  child: Row(
                    children: [
                      Text("Lap", style: TextStyle(color: primaryColor, fontSize: subTitleFontSize),),
                      const SizedBox(width: 10,),
                      Icon(Icons.add_alarm, color: primaryColor, size: subTitleFontSize,),                      
                    ]
                  )
                )
                :
                const SizedBox(width: 0,)
            ],
          ),
          Container(
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1, color: secondaryColor))),
            padding: const EdgeInsets.all(defaultPadding),
          ),
          const SizedBox(height: 10,),
          widget.isSmallScreen ? smallHeader : wideHeader,
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: ListView(
              controller: controller,
              children: [
                for(LapData data in lapData)
                  data.asWidget(widget.isSmallScreen),
                if(lapTimerStarted)
                  LapDataTracker(isSmallScreen: widget.isSmallScreen)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Widget wideHeader = Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    SizedBox(width: 50, child: Text("Lap", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 100, child: Text("Laptime", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 100, child: Text("SoC", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 100, child: Text("Delta Soc", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 100, child: Text("Min Volt", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("FL Motor T", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("FR Motor T", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("RL Motor T", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("RR Motor T", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("FL Inv T", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("FR Inv T", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("RL Inv T", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 90, child: Text("RR Inv T", style: TextStyle(color: primaryColor),)),
  ],
);

Widget smallHeader = Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    SizedBox(width: 50, child: Text("Lap", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 100, child: Text("Laptime", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 50, child: Text("SoC", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 50, child: Text("D SoC", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 50, child: Text("V min", style: TextStyle(color: primaryColor),)),
    SizedBox(width: 60, child: Text("Motor T", style: TextStyle(color: primaryColor),)),
    const SizedBox(width: 40,),
    const SizedBox(width: 50,),
    const SizedBox(width: 50,),
    SizedBox(width: 50, child: Text("Inv T", style: TextStyle(color: primaryColor),)),
    const SizedBox(width: 50,),
    const SizedBox(width: 50,),
    const SizedBox(width: 50,),
  ],
);