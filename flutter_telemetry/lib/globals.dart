import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/indicators/lap_display.dart';

String activeTab = "CONFIG";
String dir = "";

Color primaryColor = primaryColorDark;
Color secondaryColor = secondaryColorDark;
Color bgColor = bgColorDark;
Color textColor = textColorDark;

List<TerminalElement> terminalQueue = []; // ide mindenki pakol akárhonnan
int displayLevel = 3;

List<TelemetryAlert> alerts = []; // ide csak a config tab pakol, és a main egy isolateben elindít egy alerthandlert

DateTime? lastBrightloopMAH;

List<double> tempBrakepoints = [-double.infinity, 1, 20, 30, 35, 40, 45, 50, double.infinity];
List<Color> tempColorBank = [Colors.white, Colors.blue, Colors.green.shade800, Colors.yellow, Colors.orange.shade800, Colors.red, Colors.purple, Colors.black];

DateTime lapStart = DateTime.now();
bool lapTimerStarted = false;
bool useAutoTrigger = false;
List<LapData> lapData = [];

List<VirtualSignal> virtualSignals = [
  VirtualSignal(
    ["AMK1_Torque_Limit_Positive", "AMK1_Torque_Limit_Negative"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      if(first == 0){
        return second;
      }
      return first;
    }),
    "VIRT_AMK1_LIMIT"
  ),
  VirtualSignal(
    ["AMK2_Torque_Limit_Positive", "AMK2_Torque_Limit_Negative"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      if(first == 0){
        return second;
      }
      return first;
    }),
    "VIRT_AMK2_LIMIT"
  ),
  VirtualSignal(
    ["AMK3_TorqueLimitPositive", "AMK3_TorqueLimitNegative"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      if(first == 0){
        return second;
      }
      return first;
    }),
    "VIRT_AMK3_LIMIT"
  ),
  VirtualSignal(
    ["AMK4_TorqueLimitPositive", "AMK4_TorqueLimitNegative"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      if(first == 0){
        return second;
      }
      return first;
    }),
    "VIRT_AMK4_LIMIT"
  ),
  VirtualSignal(
    ["HV_Current", "HV_Voltage_After_AIRs"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      return first * second;
    }),
    "VIRT_HV_POWER_OUT"
  ),
  VirtualSignal(
    ["APPS1_validity", "APPS2_validity"],
    ((listOfSignals){
      int first = signalValues[listOfSignals[0]]!.last.toInt();
      int second = signalValues[listOfSignals[1]]!.last.toInt();
      return first * second;  // bool and
    }),
    "VIRT_APPS_VALID"
  ),
  VirtualSignal(
    ["STA1_validity", "STA1_validity"],
    ((listOfSignals){
      int first = signalValues[listOfSignals[0]]!.last.toInt();
      int second = signalValues[listOfSignals[1]]!.last.toInt();
      return first * second;  // bool and
    }),
    "VIRT_STA_VALID"
  ),
  VirtualSignal(
    ["APPS1_position", "APPS2_posiition"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      return (first + second)/2;
    }),
    "VIRT_AVG_APPS"
  ),
  VirtualSignal(
    ["STA1_position", "STA2_position"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      return (first + second)/2;
    }),
    "VIRT_AVG_STA"
  ),
  VirtualSignal(
    ["Acc_Front_YawRate"],
    ((listOfSignals){
      num val = signalValues[listOfSignals[0]]!.last;
      return val * deg2rad;
    }),
    "VIRT_ACC_FRONT_YAW_RAD"
  ),
  VirtualSignal(
    ["VDCDCOutput1Average", "IDCDCOutput1Average"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      return first * second;
    }),
    "VIRT_BRIGHTLOOP_CH1_POWER"
  ),
  VirtualSignal(
    ["VDCDCOutput1Average", "IDCDCOutput1Average"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      return first * second;
    }),
    "VIRT_BRIGHTLOOP_CH2_POWER"
  ),
  VirtualSignal(
    ["NDCDCOutputOverload1Count", "NDCDCOutputOverload2Count"],
    ((listOfSignals){
      dynamic first = signalValues[listOfSignals[0]]!.last;
      dynamic second = signalValues[listOfSignals[1]]!.last;
      return first + second;
    }),
    "VIRT_BRIGHTLOOP_OLC"
  ),
  VirtualSignal(
    ["IDCDCOutput1Average", "IDCDCOutput2Average"],
    ((listOfSignals){
      dynamic i_1 = signalValues[listOfSignals[0]]?.last;
      dynamic i_2 = signalValues[listOfSignals[1]]?.last;
      if(i_1 == null || i_2 == null){
        return 0;
      }
      if(lastBrightloopMAH == null){
        lastBrightloopMAH = DateTime.now();
        return 0;
      }
      else{
        DateTime now = DateTime.now();
        double diffmH = now.difference(lastBrightloopMAH!).inMilliseconds / 3600;  // milliHours
        lastBrightloopMAH = now;
        return signalValues["VIRT_BRIGHTLOOP_LV_MAH"]!.last + diffmH * (i_1 + i_2);
      }
    }),
    "VIRT_BRIGHTLOOP_LV_MAH"
  ),
  VirtualSignal(
    ["HV_Cell_ID", "HV_Cell_Voltage", "HV_Cell_Temperature"],
    ((listOfSignals){
      hvCellTemps[signalValues[listOfSignals[0]]!.last.toString()] = signalValues[listOfSignals[2]]!.last;
      hvCellVoltages[signalValues[listOfSignals[0]]!.last.toString()] = signalValues[listOfSignals[1]]!.last;
    }),
    "INDEPENDENT_SIGNAL"
  ),
  VirtualSignal(
    ["HV_Current"],
    ((listOfSignals){
      if(lapTimerStarted){
        if(lapHVCurrent.length < 4320000){  // 12 hours worth of data at 100Hz  ~ 34 MB
          lapHVCurrent.add(signalValues[listOfSignals[0]]!.last);
        }
        else{
          terminalQueue.add(TerminalElement("Elaludtál he", 0));
        }
      }
    }),
    "INDEPENDENT_SIGNAL"
  ),
];

// live settings  [val, min, max]
Map<String, List<int>> settings = {  // TODO letekeréskor törölni kell a régieket
  "refreshTimeMS" : [100,50,2000],
  "chartrefreshTimeMS": [100,5,2000],
  "signalValuesToKeep": [512,128,4096],
  "chartSignalValuesToKeep": [512,128,4096],
  "chartLoadMode": [1,0,1],
  "listenPort": [8998, 1000, 65535]
};