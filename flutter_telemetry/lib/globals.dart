import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';

String activeTab = "CONFIG";

Color primaryColor = primaryColorDark;
Color secondaryColor = secondaryColorDark;
Color bgColor = bgColorDark;
Color textColor = textColorDark;

List<String> terminalQueue = []; // ide mindenki pakol akárhonnan
bool newItemInTerminalQueue = false;

//List<AlertDescriptor> alerts = []; // ide csak a config tab pakol, és a main egy isolateben elindít egy alerthandlert

// live settings  [val, min, max]
Map<String, dynamic> settings = {
  "refreshTimeMS" : [100,50,2000],
  "chartrefreshTimeMS": [30,5,2000],
  "signalValuesToKeep": [128,48,1024],
  "chartSignalValuesToKeep": [128,48,1024],
};

Map<String, String> settingsToLabel = {
  "refreshTimeMS" : "Refresh time in ms",
  "chartrefreshTimeMS": "Chart refresh time in ms",
  "signalValuesToKeep": "Internal buffer",
  "chartSignalValuesToKeep": "Data points on chart",
};