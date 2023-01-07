import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_telemetry/constants.dart';
import 'package:flutter_telemetry/indicators/indicators.dart';

class OverviewTab extends StatefulWidget{
    const OverviewTab({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OverviewTabState();
  }
}

class OverviewTabState extends State<OverviewTab>{
	late Timer timer;
  double threshold = 1220;
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
      return ListView(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              NumericPanel(
                flex: 1,
                subscribedSignals: ["Vectornav_yaw_rate_rear_value", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
                colsize: 4, title: "test numeric panel"),
              BooleanPanel(
                flex : 1,
                subscribedSignals: ["Bosch_yaw_rate", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
                colsize: 4, title: "test led panel"),
            ],
          ),
          const ScaleIndicator(subscribedSignal: "Bosch_yaw_rate", maxValue: 1, minValue: -1),
          const RotaryIndicator(subscribedSignal: "Bosch_yaw_rate", numofStates: 12),
          const Plot2D(subscribedSignals: ["Bosch_yaw_rate", "Bosch_yaw_rate"], title: "Bosch_yaw_rate", maxValue: 5),
          const WaveformChart(subscribedSignals: ["Bosch_yaw_rate"], title: "asd")
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
      );
    }
    else{
      return ListView(
        children: const [
          //NumericIndicator(getData: widget.getSignalValues, subscribedSignal: "Bosch_yaw_rate")
          NumericPanel(
            flex: 1,
            subscribedSignals: ["Vectornav_yaw_rate_rear_value", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
            colsize: 4, title: "test numeric panel"),
          BooleanPanel(
            flex : 1,
            subscribedSignals: ["Bosch_yaw_rate", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Xavier_orientation", "Bosch_yaw_rate", "Vectornav_yaw_rate_rear_value"],
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
      );
    }
  }
  
  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}