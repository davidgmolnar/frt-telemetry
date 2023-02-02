import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';

String activeTab = "CONFIG";

Color primaryColor = primaryColorDark;
Color secondaryColor = secondaryColorDark;
Color bgColor = bgColorDark;
Color textColor = textColorDark;

List<TerminalElement> terminalQueue = []; // ide mindenki pakol akárhonnan
int displayLevel = 3;

List<TelemetryAlert> alerts = []; // ide csak a config tab pakol, és a main egy isolateben elindít egy alerthandlert

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
];

// live settings  [val, min, max]
Map<String, dynamic> settings = {
  "refreshTimeMS" : [100,50,2000],
  "chartrefreshTimeMS": [20,5,2000],
  "signalValuesToKeep": [128,48,4096],
  "chartSignalValuesToKeep": [128,48,4096],
};

Map<String, String> settingsToLabel = {
  "refreshTimeMS" : "Refresh time in ms",
  "chartrefreshTimeMS": "Chart refresh time in ms",
  "signalValuesToKeep": "Internal buffer",
  "chartSignalValuesToKeep": "Data points on chart",
};