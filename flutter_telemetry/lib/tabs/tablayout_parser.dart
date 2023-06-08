import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/components/config_terminal.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/globals.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';
import 'package:flutter_telemetry/tabs/tabs.dart';

abstract class TabLayoutParser{

  static TabLayout get failedToParseTab => const TabLayout(shortcutLabels: [], layoutBreakpoints: [], layout: [
    SizedBox(
      height: 300,
      child: Center(
        child: Text(
          "Failed to parse tab, check config tab for more info",
          style: TextStyle(fontSize: subTitleFontSize),
        ),
      ),
    )
  ], minWidth: 0);

  static NumericIndicator? _decodeNumeric(Map<String, dynamic> widgetData){
    if(widgetData.containsKey('signal') && widgetData['signal'] is String){
      return NumericIndicator(subscribedSignal: widgetData['signal']);
    }
    else{
      return null;
    }
  }

  static NumericPanel? _decodeNumericPanel(Map<String, dynamic> widgetData){
    if(widgetData.containsKey('signals') && widgetData.containsKey('title') && widgetData.containsKey('column_size')
      && widgetData['signals'] is List && widgetData['title'] is String && widgetData['column_size'] is int){
      if(widgetData['signals'].isEmpty || !widgetData['signals'].every((signal) => signal is String)){
        return null;
      }
      return NumericPanel(subscribedSignals: widgetData['signals'].map<String>((e) => e.toString()).toList(), title: widgetData['title'], colsize: widgetData['column_size'],);
    }
    else{
      return null;
    }
  }

  static BooleanIndicator? _decodeBoolean(Map<String, dynamic> widgetData){
    if(widgetData.containsKey('signal') && widgetData.containsKey('is_inverted')
      && widgetData['signal'] is String && widgetData['is_inverted'] is int){
      if(widgetData['is_inverted'] > 1 && widgetData['is_inverted'] < 0){
        return null;
      }
      if(widgetData['is_inverted'] == 0){
        return BooleanIndicator(subscribedSignal: widgetData['signal']);
      }
      else{
        return BooleanIndicator(subscribedSignal: widgetData['signal'], isInverted: true,);
      }
    }
    else{
      return null;
    }
  }

  static BooleanPanel? _decodeBooleanPanel(Map<String, dynamic> widgetData){
    if(widgetData.containsKey('signals') && widgetData.containsKey('title') && widgetData.containsKey('column_size')
      && widgetData['signals'] is List && widgetData['title'] is String && widgetData['column_size'] is int){
      if(widgetData['signals'].isEmpty || !widgetData['signals'].every((signal) => signal is String)){
        return null;
      }
      return BooleanPanel(subscribedSignals: widgetData['signals'].map<String>((e) => e.toString()).toList(), title: widgetData['title'], colsize: widgetData['column_size'],);
    }
    else{
      return null;
    }
  }

  static ScaleIndicator? _decodeScale(Map<String, dynamic> widgetData){
    if(widgetData.containsKey('signal') && widgetData.containsKey('max_value') && widgetData.containsKey('min_value')
      && widgetData['signal'] is String && widgetData['max_value'] is num && widgetData['min_value'] is num){
      return ScaleIndicator(subscribedSignal: widgetData['signal'], maxValue: widgetData['max_value'], minValue: widgetData['min_value'],);
    }
    else{
      return null;
    }
  }

  static TimeSeriesChart? _decodeChart(Map<String, dynamic> widgetData){
    if(widgetData.containsKey('signals') && widgetData.containsKey('max_value') && widgetData.containsKey('min_value') && widgetData.containsKey('title')
      && widgetData['signals'] is List && widgetData['max_value'] is num && widgetData['min_value'] is num && widgetData['title'] is String){
      if(widgetData['signals'].isEmpty || !widgetData['signals'].every((signal) => signal is String)){
        return null;
      }
      return TimeSeriesChart(subscribedSignals: widgetData['signals'].map<String>((e) => e.toString()).toList(), max: widgetData['max_value'].toDouble(), min: widgetData['min_value'].toDouble(), title: widgetData['title'],);
    }
    else{
      return null;
    }
  }

  static Widget? _decodeWidget(Map<String, dynamic> widgetData){
    switch (widgetData["widget_type"]) {
      case "numeric":
        return _decodeNumeric(widgetData);
      case "numeric_panel":
        return _decodeNumericPanel(widgetData);
      case "boolean":
        return _decodeBoolean(widgetData);
      case "boolean_panel":
        return _decodeBooleanPanel(widgetData);
      case "scale":
        return _decodeScale(widgetData);
      case "chart":
        return _decodeChart(widgetData);
      default:
        return null;
    }
  }

  static Widget _recursiveBuild(Map<String, dynamic> widgetData){
    if(widgetData["widget_type"] == "row"){
      List<Widget> children = widgetData['children'].map<Widget>((subWidgetData) {
        return _recursiveBuild(subWidgetData);
      }).toList();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      );
    }
    else if(widgetData["widget_type"] == "column"){
      List<Widget> children = widgetData['children'].map<Widget>((subWidgetData) {
        return _recursiveBuild(subWidgetData);
      }).toList();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
    else{
      Widget? decoded = _decodeWidget(widgetData);
      if(decoded == null){
        terminalQueue.add(TerminalElement("Failed to parse $widgetData", 2));
      }
      return decoded ?? const SizedBox();
    }
  }

  static Future<TabLayout?> _tryParseFromFile(String relativePath) async {
    File sessionFile = File("$dir$relativePath");
    if(!await sessionFile.exists()){
      return null;
    }
    Map<String, dynamic> tabData = await sessionFile.readAsString().then((value) {return jsonDecode(value) as Map<String, dynamic>;});

    List<String>? shortcutLabels;
    List<double>? layoutBreakpoints;
    List<Widget> layout = [];
    int? minWidth;
    
    for(String key in tabData.keys){
      switch (key) {
        case "min_tab_width":
          minWidth ??= tabData[key];
          break;
        case "scroll_coordinates":
          if(tabData[key] is List && tabData[key].every((value) => value is num)){
            layoutBreakpoints ??= (tabData[key] as List).map<double>((value) => value.toDouble()).toList();
          }
          break;
        case "scroll_point_labels":
          if(tabData[key] is List && tabData[key].every((value) => value is String)){
            shortcutLabels ??= (tabData[key] as List).map<String>((value) => value.toString()).toList();
          }
          break;
        default:
          layout.add(_recursiveBuild(tabData[key]));
      }
    }

    if(layout.isEmpty){
      return null;
    }

    minWidth ??= 0;
    shortcutLabels ??= [];
    layoutBreakpoints ??= [];

    if(shortcutLabels.length != layoutBreakpoints.length){
      return null;
    }
    return TabLayout(shortcutLabels: shortcutLabels, layoutBreakpoints: layoutBreakpoints, layout: layout, minWidth: minWidth);
  }

  static Future<TabLayout> load(String relativePath) async {
    TabLayout? tabLayout;
    try{
      tabLayout = await _tryParseFromFile(relativePath);
    } catch(exc){
      return failedToParseTab;
    }
    if(tabLayout == null){
      return failedToParseTab;
    }
    return tabLayout;
  }
}