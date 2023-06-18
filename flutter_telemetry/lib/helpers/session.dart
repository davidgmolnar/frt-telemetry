import 'dart:convert';
import 'dart:io';

import 'package:flutter_telemetry/components/config_alerts.dart';
import 'package:flutter_telemetry/components/config_settings.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/data.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/helpers/helpers.dart';

/* session.json
  - settings
  - signals
  - colortheme
*/

Future<void> getCurrentDirectory() async {
  dir = Platform.resolvedExecutable;
  if(Platform.isWindows){  // Linux nem buzi
    dir = dir.replaceAll(r'\', '/');
  }
  dir = dir.split('/').reversed.toList().sublist(1).reversed.toList().join('/');
  if(Platform.isWindows){
    dir = dir.replaceAll('/', r'\');
    dir = dir + r'\';
  }
  else if(Platform.isLinux){
    dir = dir + r'/';
  }
  else{
    terminalQueue.add(TerminalElement("Unsupported OS", 0));
  }
}

Future<void> loadSession() async {
  File sessionFile = File("${dir}session.json");
  bool exists = await sessionFile.exists();
  if(!exists){
    terminalQueue.add(TerminalElement("Session file not found, default settings loaded", 2));
    return;
  }
  Map sessionData = await sessionFile.readAsString().then((value) {return jsonDecode(value) as Map<String, dynamic>;});
  if(sessionData.containsKey("settings")){
    for(String sessionSetting in sessionData["settings"].keys){
      if(settings.containsKey(sessionSetting)){
        if(sessionData["settings"][sessionSetting] > settings[sessionSetting]!.minValue && sessionData["settings"][sessionSetting] < settings[sessionSetting]!.maxValue){
          settings[sessionSetting]!.value = sessionData["settings"][sessionSetting];
        }
      }
    }
  }
  if(sessionData.containsKey("alerts")){
    for(String alertSignal in sessionData["alerts"].keys){
      if(sessionData["alerts"][alertSignal].containsKey("min") && sessionData["alerts"][alertSignal].containsKey("max") && sessionData["alerts"][alertSignal].containsKey("inRange") && sessionData["alerts"][alertSignal].containsKey("isActive")){
        alerts.add(TelemetryAlert.fillFromJson(sessionData["alerts"][alertSignal], alertSignal));
      }
    }
  }
  if(sessionData.containsKey("colortheme")){
    String theme = sessionData["colortheme"];
    if((theme == "DARK" && textColor != textColorDark) || (theme == "BRIGHT" && textColor != textColorBright)){
      toggleColorTheme();
    }
  }
  if(sessionData.containsKey("activetab")){
    activeTab = sessionData["activetab"];
  }

  if(sessionData.containsKey("signals")){
    for (String signal in sessionData["signals"]) {
      signalValues[signal] = [];
      signalTimestamps[signal] = [];
    }
  }
  if(sessionData.containsKey("canPathList")){
    for(String path in sessionData["canPathList"]){
      canPathList.add(path);
    }
  }
  terminalQueue.add(TerminalElement("Session file found, settings loaded", 3));
}

Future<void> saveSession() async {
  File sessionFile = File("${dir}session.json");
  bool exists = await sessionFile.exists();
  Map sessionData = {};
  if(exists){
    sessionData = await sessionFile.readAsString().then((value) {return jsonDecode(value) as Map<String, dynamic>;});
  }
  else{
    sessionFile = await sessionFile.create();
  }

  sessionData["settings"] = {};
  for(String setting in settings.keys){
    sessionData["settings"][setting] = settings[setting]!.value;
  }

  if(!sessionData.containsKey("alerts") || alerts.isEmpty){
    sessionData["alerts"] = {};
  }
  else{
    for(TelemetryAlert alert in alerts){
      sessionData["alerts"][alert.signal] = alert.toJson();
    }
  }

  if(signalValues.keys.isNotEmpty){
    sessionData["signals"] = signalValues.keys.toList();
  }
  sessionData["colortheme"] = textColor == textColorDark ? "DARK" : "BRIGHT";
  sessionData["activetab"] = activeTab;
  sessionData["canPathList"] = canPathList;
  // Alerts

  sessionFile = await sessionFile.writeAsString(const JsonEncoder.withIndent('    ').convert(sessionData));
}