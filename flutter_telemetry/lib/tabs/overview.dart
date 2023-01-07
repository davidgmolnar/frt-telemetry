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
          const Titlebar(title: "Sensor checks"),
          Row(
            children: [
              const BooleanPanel(
                subscribedSignals: [
                  "APPS1_validity",
                  "APPS2_validity",
                  "APPS_plausibility",
                  "STA1_validity",
                  "STA2_validity",
                  "STA_plausibility",
                  "Brake_force_validity",
                  "Brake_pressure_front_validity",
                  "Brake_pressure_rear_validity",
                ],
                colsize: 9,
                title: "Sensor leds"
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    ScaleIndicator(subscribedSignal: "APPS1_position", maxValue: 0, minValue: 100),
                    ScaleIndicator(subscribedSignal: "APPS2_posiition", maxValue: 0, minValue: 100),
                    ScaleIndicator(subscribedSignal: "STA1_position", maxValue: 0, minValue: 180),
                    ScaleIndicator(subscribedSignal: "STA2_position", maxValue: 0, minValue: 180),
                  ],),
                  Row(children: [

                  ],),
                ]
              )
            ],
          )
        ],
      );
    }
    else{
      return ListView(
        children: [
          
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