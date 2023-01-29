import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';

String activeTab = "CONFIG";

Color primaryColor = primaryColorDark;
Color secondaryColor = secondaryColorDark;
Color bgColor = bgColorDark;
Color textColor = textColorDark;

List<TerminalElement> terminalQueue = []; // ide mindenki pakol akárhonnan
int displayLevel = 3;

TelemetryAlert getAlert(){
  TelemetryAlert tmp = TelemetryAlert(true);
  tmp.max = 100;
  return tmp;
}

TelemetryAlert tmp = getAlert();
List<TelemetryAlert> alerts = []; // ide csak a config tab pakol, és a main egy isolateben elindít egy alerthandlert

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