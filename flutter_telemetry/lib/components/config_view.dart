import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/indicators/boolean_indicator.dart';
import 'package:flutter_telemetry/indicators/boolean_panel.dart';
import 'package:flutter_telemetry/indicators/numeric_indicator.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/indicators/numeric_panel.dart';
import 'package:flutter_telemetry/indicators/plot_2d.dart';
import 'package:flutter_telemetry/indicators/rotary_indicator.dart';
import 'package:flutter_telemetry/indicators/scale_indicator.dart';
import 'package:flutter_telemetry/indicators/waveform_chart.dart';

class ConfigView extends StatefulWidget{
    ConfigView({
    Key? key,
    required this.getSignalValues,
  }) : super(key: key);

  final Function getSignalValues;

  @override
  State<StatefulWidget> createState() {
    return ConfigViewState();
  }
}

class ConfigViewState extends State<ConfigView>{
	late Timer timer;
  double threshold = 1200;
  bool isSmall = false;

  @override
  void initState() {
      super.initState();
      timer = Timer.periodic(const Duration(milliseconds: refreshTimeMS), (Timer t) => updateLayout());
    }

  void updateLayout(){  
    if(context.size!.width < threshold && !isSmall){
      setState(() {
        isSmall = true;
      });
    }
    else if(context.size!.width > threshold && isSmall){
      setState(() {
        isSmall = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(!isSmall){
      return Expanded(
        flex: screenFlex,
        child: ListView(
          children: [
            //NumericIndicator(getData: widget.getSignalValues, subscribedSignal: "Bosch_yaw_rate")
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                NumericPanel(
                  flex: 1,
                  getData: widget.getSignalValues,
                  subscribedSignals: const ["Vectornav_yaw_rate_rear_value", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
                  colsize: 4, title: "test numeric panel"),
                BooleanPanel(
                  flex : 1,
                  getData: widget.getSignalValues,
                  subscribedSignals: const ["Bosch_yaw_rate", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
                  colsize: 4, title: "test led panel"),
              ],
            ),
            /*Row(
              children: [
                BooleanPanel(
                  flex : 1,
                  getData: widget.getSignalValues,
                  subscribedSignals: const ["Bosch_yaw_rate", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
                  colsize: 3, title: "test led panel"),
                /*ScaleIndicator(
                  getData: widget.getSignalValues,  
                  subscribedSignal: "Bosch_yaw_rate",
                  maxValue: 100,
                  minValue: 0,
                  flex: 1),
                RotaryIndicator(
                  getSignalValues: widget.getSignalValues,
                  subscribedSignal: "Bosch_yaw_rate",
                  numofStates: 12,),
                Plot2D(
                  getSignalValues: widget.getSignalValues,
                  title: "g-g",
                  maxValue: 3,
                  subscribedSignals: ["Bosch_yaw_rate", 'Bosch_yaw_rate']),*/
              ],
              ),*/
            /*WaveformChart(
              flex: 1,
              getData: widget.getData,
              subscribedSignals: const ['Bosch_yaw_rate'],
              title: "test waveform chart"),*/
          ],
        )
      );
    }
    else{
      return Expanded(
        flex: screenFlex,
        child: ListView(
          children: [
            //NumericIndicator(getData: widget.getSignalValues, subscribedSignal: "Bosch_yaw_rate")
            NumericPanel(
              flex: 1,
              getData: widget.getSignalValues,
              subscribedSignals: const ["Vectornav_yaw_rate_rear_value", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
              colsize: 4, title: "test numeric panel"),
            BooleanPanel(
              flex : 1,
              getData: widget.getSignalValues,
              subscribedSignals: const ["Bosch_yaw_rate", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
              colsize: 4, title: "test led panel"),
            /*Row(
              children: [
                BooleanPanel(
                  flex : 1,
                  getData: widget.getSignalValues,
                  subscribedSignals: const ["Bosch_yaw_rate", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
                  colsize: 3, title: "test led panel"),
                /*ScaleIndicator(
                  getData: widget.getSignalValues,  
                  subscribedSignal: "Bosch_yaw_rate",
                  maxValue: 100,
                  minValue: 0,
                  flex: 1),
                RotaryIndicator(
                  getSignalValues: widget.getSignalValues,
                  subscribedSignal: "Bosch_yaw_rate",
                  numofStates: 12,),
                Plot2D(
                  getSignalValues: widget.getSignalValues,
                  title: "g-g",
                  maxValue: 3,
                  subscribedSignals: ["Bosch_yaw_rate", 'Bosch_yaw_rate']),*/
              ],
              ),*/
            /*WaveformChart(
              flex: 1,
              getData: widget.getData,
              subscribedSignals: const ['Bosch_yaw_rate'],
              title: "test waveform chart"),*/
          ],
        )
      );
    }
  }
}